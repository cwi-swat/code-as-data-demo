module HashContract

import Message;
import lang::java::m3::AST; 
import lang::java::m3::Core;
import Relation;  
import util::IDEServices;


public loc equalsMethod = |java+method:///java/lang/Object/equals(java.lang.Object)|;
public loc hashCodeMethod = |java+method:///java/lang/Object/hashCode()|;

void tagHashCodeMethods(M3 m) {
  ms = m.methodOverrides<to,from>[hashCodeMethod];

  registerDiagnostics([info("overrides Object.hashCode()", l) | l <- ms]);
}

void clearHashCodeTags(M3 m) {
  unregisterDiagnostics([*m.containment<0>]);
}

@doc{find classes with hashCode methods that do not have an equal method with it}
set[Message] checkEqualsContract(M3 m) {
  overrides = (m.methodOverrides<to,from>)+; // `+` is transitive closure : A overrides B overrides C, so "A overrides C"

  equals = overrides[equalsMethod];
  hashCodes = overrides[hashCodeMethod];

  violators 
    = m.containment<to,from>[equals]
    - m.containment<to,from>[hashCodes]
    // your analysis does not have to work for EVERY project out there, only for yours
    // - {cl | cl <- classes(m), abstract() in m.modifiers[cl]}
    ;
  
  return { warning("hashCode not implemented", onlyEquals)
    | cl <- violators, onlyEquals <- m.containment[cl] & equals };
}

set[Message] checkEqualsAndHashUseSameFields(M3 m) {
  overrides = (m.methodOverrides<to,from>)+;

  equals = overrides[equalsMethod];
  hashCodes = overrides[hashCodeMethod];
  
// (equals x hashCode) = (equals x class) o  (class x hashCode)
  pairs = rangeR(m.containment, equals)<1,0> o rangeR(m.containment, hashCodes);
     
  return 
    { warning("equals also uses <f.file>", hs)
    | <eq, hs> <- pairs, f <- m.fieldAccess[eq] - m.fieldAccess[hs]}
    +
    { warning("hashCode also uses <(f.file)>", eq)
    | <eq, hs> <- pairs, f <- m.fieldAccess[hs] - m.fieldAccess[eq]};
}


// res = checkEqualsContract(pdb);
// import util::ResourceMarkers;
// addMessageMarkers(res);
// res = checkEqualsAndHashUseSameFields(pdb);
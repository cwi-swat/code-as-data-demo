module ClassDiagramExtraction

import analysis::m3::Core;
import lang::java::m3::Core;
import lang::java::m3::AST;
import IO;
import String;

bool isStatic(M3 m, loc entity)
    = <entity, \static()> in m.modifiers;

rel[loc, loc] createClassReferenceModel(M3 m)
    = { <c, t> | c <- classes(m), f <- fields(m, c), !isStatic(m, f), <f, loc t> <- m.typeDependency };

   
rel[loc, loc] createSimplerClassReferenceModel(M3 m) {
    domainClasses = classes(m);

    testClasses = { d | d <- domainClasses, endsWith(d.file, "Test")}; // detect Test classes

    domainClasses -= testClasses + (m.containment+)[testClasses]; // also remove nested classes in test files

    // typeDependency filtered for only the fields we see using intersection (&)
    targetType = m.typeDependency & (fields(m) * domainClasses);

    return {
        <c, t> | c <- domainClasses, f <- fields(m, c), !isStatic(m, f), <f, t> <- targetType
    };
}

// Visualisation

void createChart(rel[loc,loc] model, loc target) {
    writeFile(target, 
        "digraph model {
        '  <for (<f,t> <- model) {>
            '  _<f.file> -\> _<t.file>
        '  <}>
        '}"
    );
}


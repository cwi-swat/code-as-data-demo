module RewriteIdioms

import IO;
import lang::java::\syntax::Java15;

loc target = |project://code-as-data-demo/src/BadProgrammer.java|;

void fixBadProgrammer() {
    writeFile(target, fixIdioms([start[CompilationUnit]]target));
}

start[CompilationUnit] fixIdioms(start[CompilationUnit] t) {
    return visit(t) {
        case (Stm)`if (!<Expr expr>)
                  ' <Stm a>
                  ' else 
                  ' <Stm b>` 
          => (Stm)`if (<Expr expr>) <Stm b> 
                  ' else <Stm a>`

        case (Stm)`if (<Expr expr>) {
                  '   return true;
                  '} else {
                  '   return false;
                  '}`
          => (Stm) `return <Expr expr>;`
            
        case (Stm)`if (<Expr cond>) <Stm a>` 
          => (Stm)`if (<Expr cond>) {
                  '   <Stm a>
                  '}`
        when (Stm)`{ <BlockStm* _> }` !:= a

        case (Stm)`if (<Expr cond>) <Stm a> else <Stm b>` 
          => (Stm)`if (<Expr cond>) {
                  '   <Stm a>
                  '} else {
                  '  <Stm b>
                  '}`
        when (Stm)`{ <BlockStm* _> }` !:= a
    
    };

}
module LoadData

import lang::java::m3::Core;
import util::ShellExec;
import String;
import IO;

@doc{Call Java language front-end and create M3 database}
M3 loadVallang() {
    return createM3FromDirectory(|project://vallang|, classPath=mavenClasspath(|project://vallang|));
}

@doc{Use mvn to find out what the classpath is for a given project}
list[loc] mavenClasspath(loc project) {
   output = exec("mvn",
        args=["-q", "exec:exec", "-Dexec.classpathScope=compile", "-Dexec.executable=echo", "-Dexec.args=%classpath"],
        workingDir=resolveLocation(project)
   );

   // Rascal is a scripting language with many familiar features. Here's a list comprehension:
   return [ |file:///| + jar | jar <- split(":", output)];
}

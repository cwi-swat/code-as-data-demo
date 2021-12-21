module ArchitectureConformance

import Message;
import lang::java::m3::Core;

public rel[loc,loc] dontTouch = {
    <|java+package:///io/usethesource/vallang/impl/fast|, |java+package:///io/usethesource/vallang/impl/persistent|>,
    <|java+package:///io/usethesource/vallang/impl/fast|, |java+package:///io/usethesource/vallang/impl/primitive|>,
    <|java+package:///io/usethesource/vallang/impl/persistent|, |java+package:///io/usethesource/vallang/impl/reference|>,
    <|java+package:///io/usethesource/vallang/impl/util/collections|, |java+package:///io/usethesource/vallang/impl/fast|>,
    <|java+package:///io/usethesource/vallang/impl/util/collections|, |java+package:///io/usethesource/vallang/impl/persistent|>,
    <|java+package:///io/usethesource/vallang/impl/util/collections|, |java+package:///io/usethesource/vallang/impl/reference|>
};

set[Message] detectViolations(M3 m, rel[loc,loc] checkFor) {
    containmentTransitive = m.containment+;
    checkForTransitive = {  *(containmentTransitive[f] * containmentTransitive[t]) |  <f,t> <- checkFor };
    allUses = (m.uses + m.fieldAccess + m.methodInvocation + m.typeDependency);
    
    return { error("<f> shouln\'t use <t>", f) | <f,t> <-  checkForTransitive & allUses};
}
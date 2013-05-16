/* This is the grammar for the LEM Rule Syntax
 * Generate the parser using:
 *   pegjs red-parser-01.pegjs
 * This generates the file red-parser-01.js
 *
 * npm install pegjs       -- to install pegjs
 *
 * MH: 15 May 2013
 */
 
start
  = lemRed*

lemRed
  = WS* theUrl:url WS* dfn:definition WS*    { return '{\n  "dkbId": ' + theUrl + ',\n  "definition": ' +  dfn + '\n}\n'}
  / WS* theUrl:url WS*                       { return '{\n  "dkbId": ' + theUrl + "\n}\n"; }

definition
  = "{" WS* rels:(pattern / item)* "}"   { return "[" + rels + "\n]"; }

relation
  = pat:pattern  { return pat; }
  / it:item      { return it;  }

item
  = hasItem WS* lit:literal WS* dfn:(definition)+ WS*  { return '\n { "hasItem": ' + lit    + ',\n  "definition": ' + dfn + "}\n"; }
  / hasItem WS* theUrl:url  WS* dfn:(definition)+ WS*  { return '\n { "hasItem": ' + theUrl + ',\n  "definition": ' + dfn + "}\n" }
  / hasItem WS* lit:literal WS*  { return '\n  { "hasItem": ' + lit    + '}';  }
  / hasItem WS* theUrl:url  WS*  { return '\n  { "hasItem": ' + theUrl + '}'; }

pattern
  = hasPattern WS* theUrl:url WS* dfn:definition WS*   { return '\n  { "hasPattern": ' + theUrl + dfn + '}'}
  / hasPattern WS* theUrl:url WS*                      { return '\n  { "hasPattern": ' + theUrl + '}'; }


hasItem
  = hasitem:"->"    { return hasitem; }

hasPattern
  = haspattern:"=>" { return haspattern; }

literal
  = "\"" str:("\\" . / [^"])* "\""     { return '"' + str.join("") + '"'; }

url
  = "http://" dkbid:[.a-zA-Z/#0-9]+  { return '"http://' + dkbid.join("") + '"'; }

WS
  = [\n\r\t ]


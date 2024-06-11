// Kunden Datenbank mit Abruf-Funktion


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


// Konstruktor für den Kunden
struct Customer{ uint id; string name; uint dateOfBirth; uint social; uint status; }

//Status für die Angabe der Daten
uint constant active = 1; uint constant pending = 2; uint constant deleted = 3;

//Data-Warehouse / Array
Contract DatabaseExample{
mapping (uint => Customer) customers;
customers[key];
public uint count = 0;

}
https://www.dappuniversity.com/articles/solidity-tutorial


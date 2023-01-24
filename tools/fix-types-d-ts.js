/*
 * Fix the Typescript declarations generated by tsd-jsdoc
 * 1) substituting "declare class" with "export class"
 * 2) making listener methods optional 
 * 3) adding the module declaration. 
 */
const MagicString = require('magic-string');
const fs = require('fs');
const assert = require('assert');
const path = require('path');

const targetFile = path.resolve(process.argv[2], 'types.d.ts'); // e.g. ../tools/dest
const targetModule = process.argv[3]; // e.g. lightstreamer-client-web

const types = fs.readFileSync(targetFile, 'utf8');
const newTypes = new MagicString(types);
fixClassDcl();
fixListeners();
addModuleDcl();
fs.writeFileSync(targetFile, newTypes.toString());

function fixClassDcl() {
    let match;
    const regex = /declare class/g;
    while (match = regex.exec(types)) {
        newTypes.overwrite(match.index, match.index + match[0].length, 'export class');
    }
}

function fixListeners() {
    const States = {
            INIT: Symbol('init'),
            BEGIN: Symbol('begin-listener'),
            METHOD: Symbol('listener-method'),
            END: Symbol('end-listener'),
            IGNORE: Symbol('ignore-dcl')
    };
    let state = States.INIT;
    
    let match;
    const regex = /(^declare class \w+Listener)|(^\})|(^\s+\w+)/gm;
    while (match = regex.exec(types)) {
//        console.log('>>>', state, match[0]);
        const [token, begin, end, method] = match;
        if (state == States.INIT && begin) {
            state = States.BEGIN;
        } else if (state == States.BEGIN && method) {
            state = States.METHOD;
        } else if (state == States.METHOD && end) {
            state = States.END;
        } else if (state == States.END && begin) {
            state = States.BEGIN;
        } else if (state == States.END) {
            state = States.IGNORE;
        } else if (state == States.IGNORE && begin) {
            state = States.BEGIN;
        }
        switch (state) {
        case States.BEGIN:
            assert(begin, token);
            // console.info(token);
            break;
        case States.METHOD:
            assert(method, token);
            if (! /constructor/.test(method)) {                
                // console.info(token);
                newTypes.overwrite(match.index, match.index + method.length, method + '?');
            }
            break;
        case States.END:
            assert(end, token);
            // console.info(token);
            break;
        case States.IGNORE:
            assert(end || method, token);
            break;
        }
    }
}

function addModuleDcl() {
    newTypes.append(`declare module '${targetModule}';`);
}

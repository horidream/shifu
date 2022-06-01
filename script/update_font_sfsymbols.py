#! python3
import json
import requests
import re
import os

path = "https://raw.githubusercontent.com/noahsark769/sfsymbols.com/master/src/data/symbols.json"
content = requests.get(path).content.decode()


def upper_repl(match):
    return match.group(1).upper()


def digit(match):
    return "_" + match.group(1)


with open(os.path.expanduser("~/Repo/Shifu/Shifu/Classes/Utils/SFSymbols.swift"), "w") as f2:
    f2.write("""import Foundation

public extension SFSymbols{
    enum Name:String, CaseIterable {""" + "\n")
    for k in json.loads(content):
        iconName = (re.sub("\.(\w)", upper_repl, k))
        iconName = (re.sub("\.(\d)", r"\1", iconName))
        iconName = (re.sub("^(\d)", digit, iconName))
        f2.write('        case `' + iconName + '` = "' + k + '"\n')
    f2.write("""    }
}
""")

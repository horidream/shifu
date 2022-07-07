#! python3
import json
import requests
import re
import os

def upper_repl(match):
    return match.group(1).upper()


def digit(match):
    return "_" + match.group(1)

sfarr = []
faarr = []
items = []

with open("./all_raw_names.txt") as f:
    for line in f:
        line = line.strip()
        if line == "":
            continue
        iconName = (re.sub("\.(\w)", upper_repl, line))
        iconName = (re.sub("\.(\d)", r"\1", iconName))
        iconName = (re.sub("^(\d)", digit, iconName))
        sfarr.append(iconName)
        items.append((iconName, line, "_sf"))





path = "https://raw.githubusercontent.com/FortAwesome/Font-Awesome/6.x/metadata/icons.json"
content = requests.get(path).content.decode()

for k, value in json.loads(content).items():
    iconName = (re.sub("-(\w)", upper_repl, k))
    iconName = (re.sub("^(\d)", digit, iconName))
    iconCode = "\\u{" + value['unicode'] + "}"
    faarr.append(iconName)
    items.append((iconName, iconCode, "_fa"))


faset = set(faarr)
sfset = set(sfarr)
intersection = faset.intersection(sfset)


with open(os.path.expanduser("~/Repo/Shifu/Shifu/Classes/Utils/Icons.swift"), "w") as f2:
    f2.write("""import Foundation

public extension Icons{
    enum Name:String, CaseIterable {
        public static var random: Icons.Name{
            return .allCases.randomElement()!
        }
        var isFontAwesome:Bool{
            rawValue.substr(-3, 3)  == "_fa"
        }
        var value: String{
            rawValue.substring(0, -3)
        }""" + "\n")
    for (k, value, suffix) in items:
        value = value + suffix
        if k in intersection:
            f2.write('        case `' + k + suffix + '` = "' + value + '"\n')
        else:
            f2.write('        case `' + k + '` = "' + value + '"\n')
    f2.write("""    }
}
""")

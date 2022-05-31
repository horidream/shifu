#! python3 
import json, requests, re, os

path = "https://raw.githubusercontent.com/FortAwesome/Font-Awesome/6.x/metadata/icons.json"
content = requests.get(path).content.decode()

def upper_repl(match):
    return match.group(1).upper() 
def digit(match):
    return "_" + match.group(1)

with open(os.path.expanduser("~/Repo/Shifu/Shifu/Classes/Utils/FontAwesome.swift"), "w") as f2:
    f2.write("""import Foundation

public extension FontAwesome{
enum Name:String, CaseIterable {""" + "\n")
    for k, value in json.loads(content).items():
        iconName = (re.sub("-(\w)", upper_repl, k))
        iconName = (re.sub("^(\d)", digit, iconName))
        iconCode = value['unicode']
        f2.write('        case `' + iconName + '` = "\\u{' + iconCode + '}"\n')
    f2.write("""    }
}
""")


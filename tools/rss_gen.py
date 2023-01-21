#!/usr/bin/env python3

from lxml import etree as ET
import datetime
import time
import email.utils
import os

today = email.utils.formatdate()
url = "https://fryzekconcepts.com"
personal_author_string = "lucas.fryzek@fryzekconcepts.com (Lucas Fryzek)"

xmlns_uris = {"atom" : "http://www.w3.org/2005/Atom"}

rss = ET.Element("rss", version="2.0", nsmap=xmlns_uris)
channel = ET.SubElement(rss, "channel")
ET.SubElement(channel, "title").text = "Fryzek Concepts"
ET.SubElement(channel, "{{{}}}link".format(xmlns_uris["atom"]), href="{}/feed.xml".format(url), rel="self", type="application/rss+xml")
ET.SubElement(channel, "link").text = url
ET.SubElement(channel, "description").text = "Lucas is a developer working on cool things"
#ET.SubElement(channel, "pubData").text = today
ET.SubElement(channel, "lastBuildDate").text = today

notes = []

build_dir = "./build"
for file in os.listdir(build_dir):
    if file.endswith(".meta"):
        path = os.path.join(build_dir, file)
        f = open(path, "r")
        note = {"name" : "".join(file.split(".")[:-1])}
        for line in f:
            line_split = line.strip().split(",")
            note[line_split[0]] = "".join(line_split[1:])
        f.close()

        notes.append(note)


notes.sort(key=lambda note: datetime.datetime.strptime(note["date"], "%Y-%m-%d"))

for note in notes:
    post_time = datetime.datetime.strptime(note["date"], "%Y-%m-%d")
    post_rfc_time = email.utils.formatdate(timeval=time.mktime(post_time.timetuple()))
    post_url = "{}/notes/{}.html".format(url, note["name"])
    item = ET.SubElement(channel, "item")
    ET.SubElement(item, "title").text = note["title"]
    ET.SubElement(item, "link").text = post_url
    ET.SubElement(item, "description").text = note["preview"]
    if "categories" in note:
        ET.SubElement(item, "category").text = note["categories"]

    ET.SubElement(item, "pubDate").text = post_rfc_time
    ET.SubElement(item, "guid").text = post_url

tree = ET.ElementTree(rss)
tree.write("html/feed.xml", encoding='utf-8', xml_declaration=True)

import ../src/nimminiz
import unittest
import os

const a_txt = "hello A from a.txt\n"
const b_txt = "hello B from b.txt\n"

suite "Zip Suite":
  test "that creating and a zip file works":
    var zip:Zip
    check open(zip, "testing.zip", fmWrite)

    var tmp:File
    check open(tmp, "a.txt", fmWrite)
    tmp.write(a_txt)
    tmp.close()
    check open(tmp, "B.txt", fmWrite)
    tmp.write(b_txt)
    tmp.close()

    check zip.len == 0
    zip.add_file("a.txt", archivePath="ooo/a.txt")
    check zip.len == 1
    zip.add_file("B.txt", archivePath="ooo/B.txt")
    check zip.len == 2

    removeFile("a.txt")
    removeFile("B.txt")

    zip.close()


    check open(zip, "testing.zip", fmRead)
    check zip.len == 2

    expect KeyError:
      discard zip.extract_file("AA.txt")

    expect KeyError:
      # default is case sensitive.
      discard zip.extract_file("A.txt")

    check zip.extract_file("a.txt") == "ooo/a.txt"
    check fileExists("ooo/a.txt")
    check $("ooo/a.txt".readFile()) == a_txt

    check zip.extract_file("a.txt", destDir="ooo/ttt/") == "ooo/ttt/ooo/a.txt"
    check fileExists("ooo/ttt/ooo/a.txt")
    check $("ooo/ttt/ooo/a.txt".readFile()) == a_txt

    check zip.extract_file("B.txt", destDir="ooo/bbb/").readFile() == b_txt
    check fileExists("ooo/bbb/ooo/B.txt")

    removeDir("ooo")
    removeFile("testing.zip")


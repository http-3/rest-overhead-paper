#!/usr/bin/env python3
# usage  python3 ../lik-results-in-db.py dbname group file


import sqlite3
import sys
import re

import traceback
import logging

def import_file_l3(file):
  print("Importing " + file)
  f = open(file, "r")
  regex = re.compile("(\|\s+INSTR_RETIRED_ANY\s+\|\s+FIXC0\s+\|\s+(?P<INS>[0-9\.e\+\-]+))[\s\S]*?(\|\s+L3 bandwidth \[MBytes\/s\]\s+\|\s+(?P<L3B>[0-9\.e\+\-]+))[\s\S]*?(\|\s+L3 data volume \[GBytes\]\s+\|\s+(?P<L3V>[0-9\.e\+\-]+))")
  Obj_size = int(file.split("-")[0])
  print (Obj_size)
  text = f.read()
  f.close()
  m = regex.search(text)
  if m:
      INS = m.group('INS')
      L3B = m.group('L3B')
      L3V = m.group('L3V')
	 #L3V = m.group('L3V')[0]
      sql = "INSERT into l3 (file, Obj_size, INS, L3B, L3V) VALUES (\"%s\",%s,%s,%s,%s)" % (file, Obj_size, INS, L3B, L3V)
      print(sql)
      conn.execute(sql)
  else:
      print("no match")

def import_file_l2(file):
  print("Importing " + file)
  f = open(file, "r")
  regex = re.compile("(\|\s+INSTR_RETIRED_ANY\s+\|\s+FIXC0\s+\|\s+(?P<INS>[0-9\.e\+\-]+))[\s\S]*?(\|\s+L2 bandwidth \[MBytes\/s\]\s+\|\s+(?P<L2B>[0-9\.e\+\-]+))[\s\S]*?(\|\s+L2 data volume \[GBytes\]\s+\|\s+(?P<L2V>[0-9\.e\+\-]+))")
  Obj_size = int(file.split("-")[0])
  print (Obj_size)
  text = f.read()
  f.close()
  m = regex.search(text)
  if m:
      INS = m.group('INS')
      L2B = m.group('L2B')
      L2V = m.group('L2V')
	 #L2V = m.group('L2V')[0]
      sql = "INSERT into l2 (file, Obj_size, INS, L2B, L2V) VALUES (\"%s\",%s,%s,%s,%s)" % (file, Obj_size, INS, L2B, L2V)
      print(sql)
      conn.execute(sql)
  else:
      print("no match")

def import_file_l2rm(file):
  print("Importing " + file)
  f = open(file, "r")
  regex = re.compile("(\|\s+L2_LINES_IN_ALL\s+\|\s+PMC0:KERNEL\s+\|\s+(?P<L2RM>[0-9]+))[\s\S]*?(\|\s+INSTR_RETIRED_ANY\s+\|\s+FIXC0\s+\|\s+(?P<INS>[0-9]+))[\s\S]*?(\|\s+CPU_CLK_UNHALTED_CORE\s+\|\s+FIXC1\s+\|\s+(?P<CUC>[0-9]+))")
  Obj_size = int(file.split("-")[0])
  print (Obj_size)
  text = f.read()
  f.close()
  m = regex.search(text)
  if m:
      L2RM = m.group('L2RM')
      INS = m.group('INS')
      CUC = m.group('CUC')
	 #L3V = m.group('L3V')[0]
      sql = "INSERT into l2rm (file, Obj_size, L2RM, INS, CUC) VALUES (\"%s\",%s,%s,%s,%s)" % (file, Obj_size, L2RM, INS, CUC)
      print(sql)
      conn.execute(sql)
  else:
      print("no match")

def import_file_l2lo(file):
  print("Importing " + file)
  f = open(file, "r")
  regex = re.compile("(\|\s+L2_LINES_OUT_DEMAND_DIRTY\s+\|\s+PMC0:KERNEL\s+\|\s+(?P<L2LO>[0-9]+))[\s\S]*?(\|\s+INSTR_RETIRED_ANY\s+\|\s+FIXC0\s+\|\s+(?P<INS>[0-9]+))[\s\S]*?(\|\s+CPU_CLK_UNHALTED_CORE\s+\|\s+FIXC1\s+\|\s+(?P<CUC>[0-9]+))")
  Obj_size = int(file.split("-")[0])
  print (Obj_size)
  text = f.read()
  f.close()
  m = regex.search(text)
  if m:
      L2LO = m.group('L2LO')
      INS = m.group('INS')
      CUC = m.group('CUC')
      sql = "INSERT into l2lo (file, Obj_size, L2LO, INS, CUC) VALUES (\"%s\",%s,%s,%s,%s)" % (file, Obj_size, L2LO, INS, CUC)
      print(sql)
      conn.execute(sql)
  else:
      print("no match")



def import_file_LLIALLOD(file):
  print("Importing " + file)
  f = open(file, "r")
  regex = re.compile("(\|\s+L2_LINES_IN_ALL\s+\|\s+PMC0:KERNEL\s+\|\s+(?P<LLIA>[0-9]+))[\s\S]*?(\|\s+L2_LINES_OUT_DEMAND_DIRTY\s+\|\s+PMC1:KERNEL\s+\|\s+(?P<LLOD>[0-9]+))[\s\S]*?(\|\s+INSTR_RETIRED_ANY\s+\|\s+FIXC0\s+\|\s+(?P<INS>[0-9]+))[\s\S]*?(\|\s+CPU_CLK_UNHALTED_CORE\s+\|\s+FIXC1\s+\|\s+(?P<CUC>[0-9]+))")
  Obj_size = int(file.split("-")[0])
  print (Obj_size)
  text = f.read()
  f.close()
  m = regex.search(text)
  if m:
      LLIA = m.group('LLIA')
      LLOD = m.group('LLOD')
      INS = m.group('INS')
      CUC = m.group('CUC')
      sql = "INSERT into LLIALLOD (file, Obj_size, LLIA, LLOD, INS, CUC) VALUES (\"%s\",%s,%s,%s,%s,%s)" % (file, Obj_size, LLIA, LLOD, INS, CUC)
      print(sql)
      conn.execute(sql)
  else:
      print("no match")
	  
	  
	  
	  
	  
	  
dbname= sys.argv[1]
lik_group = sys.argv[2]
files = sys.argv[3:]

conn = sqlite3.connect(dbname)

print("Importing : ")


sql = "CREATE TABLE IF NOT EXISTS l3(file text, Obj_size int, INS int, L3B float, L3V float)"
conn.execute(sql)
sql = "CREATE TABLE IF NOT EXISTS l2(file text, Obj_size int, INS int, L2B float, L2V float)"
#print(sql)
conn.execute(sql)
sql = "CREATE TABLE IF NOT EXISTS l2rm(file text, Obj_size int, L2RM int, INS int, CUC int)"
conn.execute(sql)
sql = "CREATE TABLE IF NOT EXISTS l2lo(file text, Obj_size int, L2LO int, INS int, CUC int)"
conn.execute(sql)
sql = "CREATE TABLE IF NOT EXISTS LLIALLOD(file text, Obj_size int, LLIA int, LLOD int, INS int, CUC int)"
conn.execute(sql)


#except Exception as e:
#  logging.error(traceback.format_exc())

for f in files:
 if lik_group == "L3":
   import_file_l3(f)
 elif lik_group == "L2":
   import_file_l2(f)
 elif lik_group.startswith("L2_LINES_OUT_DEMAND_DIRTY"):
   import_file_l2lo(f)
 elif lik_group.startswith("L2_LINES_IN_ALL"):
   import_file_l2rm(f)
 elif lik_group == "LLIALLOD":
   import_file_LLIALLOD(f)
 else:
   print ("no matching group")

conn.commit()
conn.close()

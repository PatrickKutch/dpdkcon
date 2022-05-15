#!/usr/bin/python
##############################################################################
#  Copyright (c) 2021 Intel Corporation
# 
# Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
# 
#      http://www.apache.org/licenses/LICENSE-2.0
# 
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
##############################################################################
#    File Abstract: 
#    Creates a collectd conf file based on command line parametser
#
##############################################################################
import os
import sys
import argparse
from pprint import pprint as pprint

_Version = "5.23.21 Build 1"

class ArgParser(object):
    def __init__(self):
        parser = argparse.ArgumentParser(description='launcher - generic launcher for containers.\nContact Patrick Kutch for issues.', usage='''docker [docker options] app [app options] 
        where docker and docker options are as expected.

        app [app options] can be anything, such as 'ls' or dpdk-testpmd' and all of the options for it
            ''')    

        parser.add_argument("--testonly",help="parses all options and displays what the app [app options] would be, but does not execute them.",action='store_true')        

        argList = self.cleanUpArgs()

        legalLauncherArgs=['--testonly']

        launcherArgs=[]
        appArgs=[]

        # if no params, or 1st is help then print help and exti
        if len(argList) < 1 or argList[0] =="--help" or argList[0] =="-h" or argList[0] =="-?":
            parser.parse_args(["--help"])  #let argparse do the work for us, will exit after this

        # see if there are any arguments for launcher itself
        for index,arg in enumerate(argList):
            if arg in legalLauncherArgs:
                launcherArgs.append(arg)
            else:
                appArgs.append(arg) # must be either app or [app args]

        try:
            args = parser.parse_args(launcherArgs)
            
        except Exception as ex:
            return

        launchStr = ""            
        for arg in appArgs:
            launchStr += arg + " "

        launchStr.strip()

        if args.testonly:
            print("\nSmartLauncher v{} by Patrick Kutch".format(_Version))
            print("----- Testonly mode ----")
            print(">>> Command to run within container:")
            print(launchStr)
            
        else: #go execute what was asked
            os.system(launchStr)

    def cleanUpArgs(self):
        allArgString=""
        Token = "__SPLIT_TOKEN__"
        for arg in sys.argv[1:]:
            allArgString += arg + Token

        allArgString = allArgString.strip() # get rid of last space
        
        while ", " in allArgString:
            allArgString = allArgString.replace(", ",",")

        while " ," in allArgString:
            allArgString = allArgString.replace(" ,",",")

        while "= " in allArgString:
            allArgString = allArgString.replace("= ","=")

        while " =" in allArgString:
            allArgString = allArgString.replace(" =","=")

        argList = allArgString.split(Token)

        retList = []
        # can get empty items in the list, and argparse does not like that
        for arg in argList:
            if len(arg) > 0:
                retList.append(arg)

        return retList


def main():
    ArgParser()

if __name__ == "__main__":
   try:
      main()

   except Exception as ex:
        print("Uncaught error: " + str(ex))


   



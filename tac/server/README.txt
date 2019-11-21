SICS TAC SCM Server 0.8.19 - 2008-09-02

The TAC SCM server is the server software to run the TAC SCM simulation. For 
more details, please visit http://www.sics.se/tac/

Table of Contents
------------------------------
1. System Requirements
2. How to build
3. Configuring the TAC SCM server
4. Database information
5. How to run the server
6. How to run a competition
7. A note about the SQLite JDBC connector
8. Performace considerations
9. Building documentation
10. Accessing the server
11. Special server features
  A. Controlled server seed-sets
  B. Game start offset
  C. Allowing unregistered agents
  D. Saving game seeds into sim log
  E. Controlling next simID and num games
12. Contact information


1. System Requirements
------------------------------
You will need Java SDK 1.5 or higher (you can find it at http://java.sun.com/)
to be able to develop and run this server.


2. How to build
------------------------------
The server now uses the Ant build system, which has a number of defined targets:
  prepare	Creates the proper directory structure.
  compile	Compiles the server source code.
  dist		Compiles the code and creates the output jar files.
  doxygen	Creates the doxygen documentation
  doc		Same as above
  clean		Removes compiled code, build dir, and output jar files.

You can simply run "ant" , which defaults to executing the "dist" target. When
this is finished, you should have a "scmserver.jar" file in the main directory.


3. Configuring the TAC SCM server
------------------------------
The server reads the configuration file 'config/server.conf' at startup. This 
file allows, among other things, the configuration of log levels and simulation 
implementations. There is much more documentation in the config file, with
detailed descriptions of each major configuration option.

You should at least change the password for the admin user in this file.

For TAC06 SCM simulations there is also a file 'config/tac06scm_sim.conf'
which contains information such as game length, builtin agent
implementations, etc.

4. Database Information
------------------------------
The server needs a database to store some information, such as user account 
information and simulation data. There are two options for the database:

A. Connect to a MySql database
   This option is good for running competitions, or for a long-running server. 
   If you want to run multiple servers as part of the same competition, and use
   the external score merger to merge the scores into one score table, then you
   need to use a common MySql database, with the same userid's across the entire
   competiton. More information about running competitions is available further
   down in this document.
   
B. Use SQLite for a local database.
   This option is good for experimental work, when you will be stopping and 
   starting the server for each game. This option is also good if you need to
   pre-load the user account into the database before each game, such as if you
   are running a series of games using some sort of automated system. The SQLite
   data files are standard v3 SQLite files, have the same table structure as the
   MySql database, and can be read by any SQLite library. See the note below
   regarding the patched version of the SQLite JDBC conector.

In the configuration file there are sample config options for both options.
Simply un-comment the option you decide to go with, and comment-out the other.

5. How to run the server
------------------------------
At it's simplest form, you can simply run "java -jar scmserver.jar". This will 
run the server with the 'config/server.conf' config file. If you want to see all
the command-line options, run "java -jar scmserver.jar --help".

For running competitions, where you want the server to run on a remote host for
a long time, you don't want to simply SSH into the server machine, and run the 
TAC SCM server by hand. If a network error occurs, and your SSH session is 
disconnected, then the server might be killed off on disconnect. Using the 
'screen' utility would work, however it is probably overkill as there is no way
to issue commands to the running server. All we care about is the output. The
best way is to use the 'nohup' utility to disconnect the server's output from
the controlling terminal. A script called "start_nohup.sh" is included in the
server's main directory.

6. How to run a competition
------------------------------
Please see the external readme file "README_COMPETITION.txt" for a detailed
guide to running a complete competition.

7. A note about the SQLite JDBC connector
------------------------------
At the time of this development, the SQLite JDBC connector (named SQLiteJDBC, 
and located at http://www.zentus.com/sqlitejdbc/), was at version v042,
but does not include support for retrieving the assigned SQL column type, a
feature that is used in the existing server code. The included patch can be 
applied against the SQLiteJDBC v042 source, and then recompiled to produce the 
nested jar file. We have included the patched version as a convienience.

The file included here, sqlitejdbc-v042-tacscm-patched-nested.jar, has been
slightly modified by Matthew Beckler, of the University of Minnesota's
TAC SCM group <beckler@cs.umn.edu> to work with the TAC SCM server as a
drop-in replacement for the MySql interface, replacing the older file-based
database system.

With the help of David Crawshaw, the author of SQLiteJDBC, a patch has been 
created for these changes, and is located in the "lib/" directory with the 
filename 'sqlitejdbc_tacscm_patch'.


8. Performace considerations
------------------------------
During the summer 2008 competition, it was originally planned to run the four
competition servers running on the same 8-core machine, using VMWare virtual
servers for each of the server instances. This did not work out very well, and
introduced some large latencies in each server's operation. After extensive 
troubleshooting, it was decided that the VM architecture was not particularly 
well suited to running tasks that relied on being woken-up by the OS, such as
the TAC SCM server, which schedules a 15 second wakeup timer for each day. As
cool as it would be to run a bunch of TAC SCM server instances on the same 
hardware, we experienced nothing but trouble, and it is suggested that you just
use one dedicated machine for each server instance desired.


9. Building documentation
------------------------------
Run "ant doc", and open the file "html/index.html" in your browser.


10. Accessing the server
------------------------------
Open your web browser to http://<yourcomputer>:8080/

This web interface will allow you to register agents, schedule games and 
competitions, and view the current status and game history.

11. Server special features
------------------------------
The University of Minnesota's MinneTac team has added some features to the TAC
SCM server to make it easier to conduct experimental research with the server. 
These improvements are detailed here:

A. Controlled server seed-sets
------------------------------
The server has 37 seeds that are used to seed the random number generators used
by the various subsystems. It is of great benefit to running experiments to be
able to control which seeds are used for simulations. For more information on
this feature, please see the external readme file, "README_SEED_SETS.txt".

B. Game start offset
------------------------------
If you are running multiple servers on the same hardware, such as the un-
reccomended VMWare option, it is a good idea to set each server's games to be
offset from each other by a few seconds. A configuration file option has been
added to this release of the server, called "sim.gameStartOffset". By setting
this option to a small number of seconds, all of the server's games will be 
scheduled to start at the specified number of seconds past the even minute. For
example, if you were running four servers on the same hardware, values of 
0, 4, 8, and 12 might be good for each respective server. Keep in mind that
since each day lasts 15 seconds, it doesn't really make much sense to set a
value larger than 15 for this option.

C. Allowing unregistered agents
------------------------------
In experimental situation, where a "fresh" server is run for each simulation, it
is often an inconvenience to have to register each agent for each round. In
cases like these, we have added a configuration option that will allow un-
registered agents to connect and be automatically registered, just as if they
had gone through the standard web interface. This option should be turned off
normally, and only enabled in certain experimental situations.
 
D. Saving game seeds into sim log
------------------------------
As part of the effort to provide repeatability in simulations, we have extended
the data in the server simulation log file (game.slg) to include the list of
seeds that were used for that particular game. This data is an extension of the
previous format, and "new" files are still readable under the "old" logtool.
An enhanced version of the logtool will be released to read the seed data from
a "new" log file. The seed data is automatically saved to the server sim log,
and there is no config option to change this. 

E. Controlling next simID and num games
------------------------------
To facilitate experimntation, the following two properties have been added. You 
can now control the simulationID of the next game to run, and even specify the 
total number of games to run. These options should not be used in tournaments or
other official game-running situations. There are two new config options:

sim.startsimid=123

This option allows you to specify the starting value of the simulation id,

sim.gamestorun=2
This option allows you to specify the maximum number of games allowed to run on 
this server.

Again, don't use these options in a tournament, only for experimentation.


12. Contact information
------------------------------
If you have any questions or comments regarding this server
please contact tac-dev@sics.se

-- The SICS TAC Team, the UMN MinneTac Team

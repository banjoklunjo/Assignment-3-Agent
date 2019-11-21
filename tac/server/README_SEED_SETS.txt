CONTROLLED SERVER README
-----------------


Table of Contents
-----------------
1. Description of package contents
2. Creating a seedSet (set of market conditions)
	2.1 Running a single seedSet
	2.2 Running a series of seedSets
3. Methods of using the test suite
4. Additional useful information
	4.1 Log output
	4.2 Verifying market conditions
5. Contact information


1. Description of package contents
----------------------------------
The functionality included with this version of the server will allow the server 
to take in a seedSet (a sequence of seeds) to use for random number generation, 
and run multiple games with a repeatable set of market conditions, based on the 
seeds it reads in.

Also included is a user interface to generate a set of seeds. This determines
which market factors are controlled, and which remain random. The output of this
program is used as input to the server.

2. Creating a seedSet (set of market conditions)
--------------------------------------------------
The first step is to create a set of seeds that will be used for
random number generation by the controlled server. This can be done
by editing the seedData1.dat file. The file contains a list of seeds that the
server will take as input. Each seed controls some specific random walk or other
process within the TAC SCM game. A seed value of "0" means that particular seed
will be chosen randomly. Any other value will use that seed.

To actually understand the role of each seed, you can use the GUI:

% ant
% java -cp scmserver.jar edu.umn.cs.tac.seedsetgen.SeedTree

You can now highlight any market factors from the tree, and choose
to make them random or controlled. 

For example, if you highlight "Supply", and then click the "control"
button, each supplier walk will randomly be assigned a seed value,
which is recorded in a file.

If you decide instead to highlight "Supply" and click "random", 
all seed values for the supplier walks will be determined at runtime.
Highlighting "Market Variables" (which is the root node) and
clicking "random" creates a seedSet that will cause the server to behave 
in exactly the same way as the original SICS server. 

Once you have created your seedSet, you must click "save". 
A file named "seedData1.dat" is created in the main server directory. Since the
GUI only outputs to this filename, if you wish to create multiple seedsets, you
should rename this file to something else, and continue to create seedsets.


2.1 Running a single seedSet
----------------------------
If you wish to repeatedly run one "seedData1.dat" file, simply edit the file
"numSeedSets.dat" to contain the number "1". Each game run by this server will
use the seeds specified in "seedData1.dat".

IMPORTANT NOTE: If you don't want to use the functionality of the controlled-
server, and wish to use the standard behavior of random seeds for each game, you
can simply edit the "numSeedSets.dat" file to contain the number "1", and ensure
that the "seedData1.dat" file contains all zeros.


2.2 Running a series of seedsets
--------------------------------
If you wish to run a series of "seedData_.dat" files, first create
as many seedSets as necessary, as described in section 2.2. The numerical
suffix at the end of the "seedData" filename determines the order in which
the seeds are run.

For example, if you wanted to run your agent with 30 different market
conditions, you would do the following:

1) Create seedSet files as described in section 2.2.
2) Rename the files "seedData1.dat" to "seedDataN.dat", where N is the
game in which you'd like to use this data (i.e. "seedData2.dat").
3) Repeat steps 1-2 a total of 30 times.
5) Change the value inside the numSeedSets.dat file to "30".

Then start the server as normal.

IMPORTANT NOTE: The number in the "numSeedSets.dat" file should 
correspond to the number of different seedSets you wish to run.
You must change this manually. 

So, if you choose to run 30 different market conditions, change
"numSeedSets.dat" to "30". When you start the server, the first 30 games
will load "seedData1.dat", "seedData2.dat", ..., "seedData30.dat".
Starting with the 31st game, the seedsets used will repeat from the top, with
game 31 using "seedData1.dat", game 32 using "seedData2.dat", etc.


3. Methods for using the test suite
----------------------------------
The two primary ways to use the test suite are for paired markets
testing and sensitivity analysis. For details on each of these 
methods, please refer to:
http://www-users.cs.umn.edu/~sodomka/publications/assets/Sodomka_AAAI07.pdf

One important note is that when using paired markets testing, you should
compare the two agent variations with a "paired t-test", not the standard
"students t-test". An excellent description of this test can be 
found here:
http://faculty.vassar.edu/lowry/ch12pt1.html

Another option to consider would be using Wilcoxon test, 
which does not assume a normal distribution of data like the 
paired t-test does, and thus may be an even more appropriate test. 


4. Additional useful information
--------------------------------
4.1 Log output
--------------
Every time you run a game with the controlled server, logs are created
that document which seeds were configured for that game and which seeds
were used. These can be found in the directory "logs/control/"

There are two subdirectories, seedsConfigured/ and seedsUsed/.
The files within these directories are simply "seedData.dat" files. 
If you want, you can run one of these old games by moving the .dat file
up to the main server directory, and renaming it "seedData1.dat".

If a game was configured to use all controlled market conditions, 
it's seedsConfigured/ and seedsUsed/ files will be exactly the same. 
If the game was configured to use completely random market conditions,
it's seedsConfigured/ file will consist of all zeroes, and it's corresponding
seedsUsed/ file will consist of the seeds that were randomly chosen by the
server. Thus, even if you choose to use uncontrolled market conditions (like the 
original SICS server), you can still go back and re-run games with these 
conditions at a later date.


4.2 Verifying market conditions
-------------------------------
If you are performing "paired markets testing", it will probably
be a good idea to verify that the game you ran with agent A actually
had the same market conditions as the game you ran with agent A'.
To do this, use the "diff" unix command on any two files in the 
logs/control/seedsUsed/ directory. 

% diff localhost_SIM_1.dat localhost_SIM_2.dat

If there is no output, the market conditions were the same.


5. Contact information
----------------------
If you have any problems with the test suite or any additional questions,
feel free to contact Eric Sodomka at sodo0002@umn.edu.


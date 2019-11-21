How to run a competition with the TAC SCM Server

Written by Univ. of Minnesota TAC SCM server Team - September 2008.
---------------------------------------------------------------

1. Introduction 
------------------------------
The TAC SCM server can be used to run pre-scheduled competitions. A competition
consists of a set of teams, one TAC SCM server, and a pre-set timeslot. Since 
each simulation takes 55 minutes to complete, and given that we need to run a 
relatively large number of games to have any stastical significance, it is often
the case where we want to use multiple servers running concurently in order to 
run many games in a shorter amount of time. This is indeed possible, and will be
explained in this document.

2. Setup
------------------------------
Scheduling of competitions is done through the administrator webpages. These 
pages are accessible at http://localhost:8080/admin/. Before you start the 
server, you should first edit the server config file, located in the "config"
directory. You need to change the admin password, and ensure that 'admin.pages'
is set to 'true'. You should also go to the bottom of the config file and think
carefully about what you want to set the timezone option to. I would suggest
that you leave it at 0, which is GMT, as for the international competitions, GMT
works best for everyone involved.

3. Issues with multi-server competitions
------------------------------
If you want to run a large competition on more than one server, and merge their
scores into a common score table, then there are a couple of restrictions you
need to follow. First, you need to have the same user database for all servers
involved. In 2008, we just set all of the servers to use the same database, for
both user data and the server data. This ensures that the agents' userids will 
be the same across all servers. You also need to add some interesting config 
options to the servers' config files, to help deal with the registration issue.

It has been suggested to only use one server for registration. For the main SICS
TAC SCM servers, they used their own registration page, located not on the 
TAC SCM server itself, but on their overall TAC website. For the 2008
competition, we used tac01.cs.umn.edu to handle the registrations, and simply
had the three other servers link to the main registration page on tac01. Here
are the configuration settings that affect this behavior.

For the server that will be used to do the registrations, put a line like this
in the "Information systems configuration" section. You'll need to modify it for
the specific servers you are using. This line tells that main registration
server to contact all the listed servers when it registers a new user account.

is.registration.notification=http://tac02.cs.umn.edu:8080/notify/,http://tac03.cs.umn.edu:8080/notify/,http://tac04.cs.umn.edu:8080/notify/

For the servers that are not handling the registration, we use these lines to
redirect users to the main registration server to complete their registration,

is.registration.target=_blank
is.registration.url=http://tac01.cs.umn.edu:8080/register/
is.registration.remote=true

3. Admin pages
------------------------------
Open your browser and head to http://localhost:8080/admin/

There are 5 "tabs" at the top of the page. Check out the "Help" page to get a
bit of an overview as to the administration pages. I'll only cover the
interesting things and other gotchas in this document.

"Administration" tab:
You shouldn't have to mess with anything on this page unless things have gotten 
messed up. The "Generate Result Page" and "Generate Competition Results"
sections will regenerate the output information for the specified game or 
competition id.

"Competition Scheduler" tab:
This is where you schedule the actual competition. If you want to run a comp. on
more than one server, just set up a competition on each server, with the same
agents, and then we will discuss how to set up the score merger later on.

The "Name of Competition" should be the same between all servers participating 
in the same competition. In past years, the competition has been specified as
occupying a certain range of times, so you usually want to figure the total 
number of games that will be run, and put that in as the value for "Total number
of games (int)". The start time will be in the server's timezone, as specified
in the config file. Note that the server's OS must have the correct time set, 
and the JRE must know what the timezone offset is. I'm pretty sure that 99% of 
the time the JRE will know correctly what time it is, but be sure to check the
first time you go to schedule a competition that the given server time matches
the correct time for the timezone you gave the server (probably want to use GMT)
which is visible on the "Coming games" page.

In recent years, weighted games haven't been used, nor has changing the weight 
over the weekend, or "Use lowest score if smaller than zero". Keep the "Delay
between games (minutes)" set to 5, as this allows a very tidy scheduling of 
starting games right on the hour, with 5 minutes between games.

You don't need to set the "Competition score table generator" unless you want to
do something interesting and/or dangerous by using your own table generator. As
far as I know, this does not really matter in multi-server competitions, as it
only specifies how to generate the local score table. When we get to that part,
we'll see how to set up an automated cron job to combine the multi-server scores
into a common score table.

At the bottom, in the large text box, you should put in a comma-split list of
agent usernames for this competition. The list of agents will show up in the 
"Available agents:" box, but it's a royal pain to try and check the specific
boxes that you need. Just make a list of the agent usernames and copy/paste it
into all of the servers that will be running this specific competition.

Click on "Preview Schedule", and make sure that everything looks ok. 


4. Running multi-server competitions
------------------------------
This procedure really isn't that complicated, but there are a couple of tricks
that will make things run smoothly. Basically, you run "independent" 
competitions with the same agents in the same time slot, and then use an 
external program to merge the scores from each server involved. Once you have
set up the competitions on the servers involved (let's call them tac01 and tac
tac02), we need to know the competition ID number for each server's competition.

For this example with tac01 and tac02, we need to pick one of the machines to
use to collect the combined scores. We can pick tac01 for this example. In the
server distribution, we have already created a "score_merge" directory inside 
the main server directory, so you can just use that. Here is the included
directory structure:

server/
  score_merge/
    configs/
      tac01.conf
      tac02.conf
    qualifying/
      qualifying.conf
      run_score_merge.sh
    seeding/
      seeding.conf
      run_score_merge.sh
    
You will also need to create a directory called "total" inside the main server's
specific competition directory. For example, if the competition id for tac01 is
4, then you need to create the directory 

public_html/hostname/history/competition/4/total

as it will be used as the destination directory for the combined score table.
Of course, you can always change the config file to output to whatever directory
you like. Take a look into the merging config files to see what all needs to be
changed to match the setup. The "run_score_merge.sh" scripts also need to be 
updated to fit with your server's directory structure. This script is the one
that should be called from the crontab. We had good luck with scheduling the
script to run at :58 minutes past the hour, which is during the 5 minute break
between games.

5. Contact information
------------------------------
If you have any questions or comments regarding competitions, please contact:
tac-dev@sics.se

-- Matt Beckler and the UMN Server support Team

What this project all about you ask

   This project is a proof of concept to see if I could
   create the functionality required and resolve the 
   issues of SQL injection, Cross Site Request Forgery,
   and Unicode.

   Create a web app the can upload file(s) [CSV,XLS,XLSX]
   and put them into a database. Allow the user to see
   a list of files uploaded (with timestamp) to allow
   the user to view how data was stored in the database
   after it went thru a transformation process.

   At the current time the record layout is very simple
    name (text), age (integer), utf (text)

   Please read 'Project-s_Description.docx' in the project's home directory
   for the reason behind this proof of concept.

Did it peak your interest???

From the project's home directory

Optional: Clear Database
$ sqlite3 db/up.db <create.sql

Start webserver
$ bash myscripts/run.sh

Goto http://localhost:3000 in a browser
    Upload Menu
       Upload CSV/Excel
           Choose file(s) to upload
               Note: There are sample files in 'toupload' sub
                     directory of the project
       View Upload Files
           Choose an Upload to view in the database

In case you wish to see the data in the database
$ sqlite3 db/up.db <display.sql


Running Test programs
   When running the test programs you will have to:
      0) have the web app running
      1) copy samples data files from sub-directory 'toupload'
         to the project's home directory
         WHY you say?. When the pop-up window to choose files to
         upload, it will be in the project's home directory!
           $ cp toupload/* .

Other Documents (mynotes sub-directory)
   Spreadsheet.txt
      Reasons why I chose these CPAN modules
      And Unicode issues with those modules
   Unicode.txt
      What I did for Unicode for this project
   Up.Routes.txt
      Descibes the route table used in Mojolicious
   UploadDevelopment.mdp
      Proposed 'MDP' presentation for MadMongers about my Upload project.
   Up.Project-notes.txt
      Currently describes project side opportunities
         SQL Injections
         Cross-Site Scripting (XSS) attacks
         Unicode in database
   ETL-P.mdp
      Proposed 'MDP' presentation for MadMongers about using ETL::Pipeline
   ETL-Pipeline.issues.txt
      Steps I took to install ETL:P
         Issues installing ETL:P and status print statements 
   ETL-Pipeline.development.txt
      General over view of the placement of my ETL::Pipeline modules I created.
     
Even More Fun Docs ( db sub-directory )
   db.layout.txt
      Show relationship to the 3 tables
   How2-SQL-to-DeploymentH.txt
      I prefer to start with SQL and the database.
      Then use dbicdump to create my Schema
      Then use JT Smith's DBIx::Class:DeploymentHandler scripts to control
         future modifications.

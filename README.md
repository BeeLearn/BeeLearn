[![Flutter Responsive](https://img.shields.io/badge/flutter-responsive-brightgreen.svg?style=flat-square)](https://github.com/Codelessly/ResponsiveFramework)
[![Built with TIDB](https://www.gartner.com/pi/vendorimages/pingcap_cloud-database-management-systems_1639623313902.png)](https://www.pingcap.com/)

# BeeLearn
Beelearn is a AI personalized learning platform, aim to make sure you don't access outdated contents.

## Features
[+] Multiple device sync

[+] Bit size learning

[+] AI personalization (Summarize and Enhance Topics with version)

[+] Question after every lesson (Still not available)

[+] Realtime updates (Still bug Hope to fix soon)

The client connect to beelearn api which is located at beelearn.onrender.com 

## How TiDB is used in the project ?

All data are stored on TiDB cloud including courses and others 


## Check Beelearn API 

## Admin Site 
Login to our admin site first to get access to our api endpoints

[Django Admin](https://beelearn.onrender.com/admin/)

Use this logins for password and email login
email: admin@test.com
password: admin123

## Courses 
All available courses on Beelearn
(List)[https://beelearn.onrender.com/catalogue/courses/]

## Modules 
All available modules on Beelearn
(List)[https://beelearn.onrender.com/catalogue/modules/]

## Lessons
All available lessons on Beelearn
(List)[https://beelearn.onrender.com/catalogue/courses/]

## Topics 
All available topics on Beelearn
(List)[https://beelearn.onrender.com/catalogue/topics/]

### Enhance a topic
Enhance a topic using GPT

_POST_
(Enhance)[https://beelearn.onrender.com/catalogue/topics/:id/enhance/]

### Summarize a topic 
Summarize a topic using GPT
_POST_
(Summarize)[https://beelearn.onrender.com/catalogue/topics/:id/summarize/]

More API Endpoint , Will provide api documentation soon

# Unavailable 

* Settings
* Password Login ? Can't say it's working
* Working on IOS ? Can't say don't have a macbook
* Some actions like delete and share in enhance view not functional .
* Comments and share in topics view also not working

## Realtime Capability
Djira is used for realtime updates from backend.

### What is Djira?
Djira is a socket.io that allows you to build api using django 

(Github Repo)[https://github.com/oasisMystre/djira]

### Djira Client 
Check the `djira_client` folder, we built a client to connect to djira server 

## How we used TIDB for this project?
TIDB is used in the backend to handle our data using django_tidb package 

### Why we use TIDB?
* TIDB allows horizontal scaling, we can shard our database on request anytime.
* Using TIDB allow easy to visualize database using ChatQuery from TIDB

# Project Notes
Challenges solved, designs notes etc.

Note that some fixed challenges are missing and will be added later.

### 1. Fixed Issues and Challenges

---
### 2. Notes
- A major rewrite of the core online account system is being made. Currently you're forced to pick online or local when you first load up, which is quite inconvinent if you just wanna test it out. So, the new flow will be starting the user as 'not signed in' and defaulting to local saves. Then the user can connect their account whenever they want.
- Made the decesion to just cut boosts and the prestige system in favour of this because I think it's a much more important feature.
- Another issue this rewrite will fix is too many HTTP requests to the server. So currently it autosaves every 30s, that's 2 HTTP requests every minute, per player. So the new autosave will be saving to a local .cfg file first, as though it was a local save. Then every 3 minutes, save it to the server instead. 
- Did too much in one commit again. Added the sign in flow, changes because of backend changes, changes due to adding more stats. So this could've been 3 commits. I've got to fix the upgrade lines bug, fix the main menu buttons and add the special popups for connecting an account, separate these future me!
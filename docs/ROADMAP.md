# v2 Roadmap
Rough roadmap of features I would like to implement and how I will.

Note that the future features on the README were not final.

---

#### Quick Overview
**[ ]** = To-do | **[✓]** = Complete | **[?]** Under Consideration | **[/]** = In Progress

- ~~[ ] Boosts~~
- [ ] Autoclicker
- [ ] Passive Generation
- ~~[ ] Prestige~~
- [/] Convert Online Data to Local
- [?] Offline Mode
- [ ] Encrypted .cfg Files
- [ ] Stats Screen
- [ ] Leaderboards
- [✓] Request New Code for Online Linking
- Upgrade Upgrades
    - [?] Upgrade Dependencies
    - [ ] Big PATH COMPLETE Overlay
    - [ ] Purchasable Upgrades Counter
- RequestManager.gd (Autoload) Refactor
    - [ ] Less Duplication for Requests
    - [?] Accommodate for Refresh Tokens

---

#### Implementation

FEATURES

1. **Boosts**
- There will be 2 scenes: 'boost_line.tscn' and 'boost_screen.tscn'.
- Functionally similar to upgrades.
    - 'boost_screen.tscn' handles the main screen where boosts live, filter logic etc.
    - 'boost_line.tscn' handles the loop and state. It will have 1 timer with 2 states: cooldown and active.
- Some initial boosts can be double per click and 50% crit chance.
- Boost meta (descriptiom, id, name etc), stats (length, cooldown etc) will live in a 'boosts.json' like upgrades do.
- Boosts can have upgrades.
    - They can either live in the upgrades screen or under the boosts itself. The former may be better UX as upgrades are in 1 place and not scattered.
- PlayerManager should have an _apply_boost() with a match statement. Loop through an array to apply.
    - There'll be an array called active_boosts for any boost currently active (thought only 1 should be available at once, this is future planning in case I want to change to multiple at once).

2. **Autoclicker**
3. **Passive Generation**
- Both can be implemented similarly.
- One global timer in GameManager that lasts 1s and applies biscuits directly to the user's stats.
    - Timer properties: not one shot, wait time: 1s, autostart true.
- Will require an additional stat in PlayerManager called passive_rate and autoclick_rate.
- PlayerManager refactor is likely needed. One _add_biscuits() function that applies all the calculations.
- Emit a signal, 'biscuits_changed', which can be caught by 'game.tscn' for the immediate UI and both 'upgrade_screen.tscn' and 'boost_screen.tscn' for their UX features

4. **Prestige**
- Have 1 'prestige.tscn', track how many prestige the user has done and their rewards.
- Would like to have a complex reward system where the user can pick their rewards with a new currency but if not,  this can be simplified to basic stat boost that's permanent.
- Would likely need a prestige.json

---

TECHNICAL

1. **Convert Online Data to Local**
- 2 options, this can be done on the website or in game. Leaning slightly towards the website.
- In game implementation:
    - Get the latest online data, prompt 'local_save.tscn'
    - This will require some changing to the SaveManager to allow cached data to save and load (as opposed to it being from a GET request or .cfg)
- Website implementation:
    - User clicks a button on the website to move data over
    - Backend marks the user's save as convert = true
    - Then, when Godot makes the GET request and recieves the data, it will see it is marked to convert and it will prompt 'local_save.tscn'
    - This can also serve as delete my online save function.
- This feature will likely require a local reset data option.

---

SMALL STUFF

1. **Encrypting .cfg Files**
- Godot already has built in methods for .cfg encryption.
- Simply change the method used.

2. **Big “PATH COMPLETE" When Maxing an Upgrade**
- Add an overlay and change line_complete() to unhide this.

3. **Upgrade Dependencies**
- Each upgrade can have a unlocks_upgrade field in upgrades.json.
- When an upgrade is bought, 'upgrade_screen.tscn' catches it, looks for the upgrade line and tells it to unlock.
- Will likely need to change 'upgrade_line.tscn' to have a locked/unlocked state.
- First dependency can be the player must max the autoclicker upgrade to unlock passive generation uggrade.

4. **Purchaseable Upgrades Counter**
- Add a counter to upgrade_screen.tscn to see how many upgrades can be bought
- Catch stats_changed signal and update
- Loop through all upgrade_lines and see if it's purchaseable.

5. **stats screen**
- Display all stats, such as biscuits per click, autoclick, crit chance etc.
- Can be on the main 'game.tscn' or main menu.

---

ADDITIONAL

(changes needed due to backend changes)

1. **RequestManager.gd (autoload)**
- If Godot does use refresh tokens rather than save IDs, we need to extract and store the cookie
- Then add the token to request headers
- If we do this, this also allows the user to see what devices their game account is linked too on the website.

2. **Reopen Websocket**
- Websockets will have exipiration times. The user should be able to request a new code.
- Backend sends the message, maybe a 522 connection timed out which Godot listens for.
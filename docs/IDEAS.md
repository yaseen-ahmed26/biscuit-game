# Ideas
A Collection of ideas and quality of life improvements.

Note that the future features on the README were not final.

---

### Key
**[ ]** = Proposed | **[✓]** = Complete | **[?]** Under Consideration

---

### Features

Ideas

[ ] **Autoclicker**
[ ] **Passive Generation**
- Both can be implemented similarly.
- One global timer in GameManager that lasts 1s and applies biscuits directly to the user's stats.
    - Timer properties: not one shot, wait time: 1s, autostart true.
- Will require an additional stat in PlayerManager called passive_rate and autoclick_rate.
- PlayerManager refactor is likely needed. One _add_biscuits() function that applies all the calculations.
- Emit a signal, 'biscuits_changed', which can be caught by 'game.tscn' for the immediate UI and both 'upgrade_screen.tscn' and 'boost_screen.tscn' for their UX features

[ ] **Prestige**
- Have 1 'prestige.tscn', track how many prestige the user has done and their rewards.
- Would like to have a complex reward system where the user can pick their rewards with a new currency but if not,  this can be simplified to basic stat boost that's permanent.
- Would likely need a prestige.json

[ ] **RequestManager.gd (autoload)**
- If Godot does use refresh tokens rather than save IDs, we need to extract and store the cookie
- Then add the token to request headers
- If we do this, this also allows the user to see what devices their game account is linked too on the website.

[?] **Upgrade Dependencies**
- Each upgrade can have a unlocks_upgrade field in upgrades.json.
- When an upgrade is bought, 'upgrade_screen.tscn' catches it, looks for the upgrade line and tells it to unlock.
- Will likely need to change 'upgrade_line.tscn' to have a locked/unlocked state.
- First dependency can be the player must max the autoclicker upgrade to unlock passive generation uggrade.

[ ] **Random Hover Spots**
- Random spots that appear around the main clicker.
- They provide multiples, such as 2x, 3x, 4x etc.
- PlayerManager needs a rewrite.
    - Need to specifiy the place who's asking PlayerManager to add biscuits so we can add extra paramters.
    - Also would need to standardize a formula for adding biscuits. Something like ((((per_click * click_multiplier) + milestone_bonus) * global_multipler) * double_chance) * source_multipler

[ ] **Micro Tasks**
- Essentially a list of small tasks to do to earn rewards, like a new currency or unlocks.
- Doubles as a tutorial and 'what to do' list.
- Would have a tasks.json, or Godot resources can be used for additonal helpers.
- Would require a new manager, TaskManager.

[ ] **Switch to Godot Resources than JSON**
- For boosts.json, upgrades.json, Resources are the Godot way of doing and better to prevent errors. 
- Can also attach helpers which can be removed from upgrade_line.tscn so it only handles the UI updates.

---

QoL

[ ] **Encrypting .cfg Files**
- Godot already has built in methods for .cfg encryption.
- Simply change the method used.

[ ] **Big “PATH COMPLETE" When Maxing an Upgrade**
- Add an overlay and change line_complete() to unhide this.

[ ] **Purchaseable Upgrades Counter**
- Add a counter to upgrade_screen.tscn to see how many upgrades can be bought
- Catch stats_changed signal and update
- Loop through all upgrade_lines and see if it's purchaseable.

[ ] **Stats Screen**
- Display all stats, such as biscuits per click, autoclick, crit chance etc.
- Can be on the main 'game.tscn' or main menu.

---

Completed

[✓] **Reopen Websocket**
- Websockets will have exipiration times. The user should be able to request a new code.
- Backend sends the message, maybe a 522 connection timed out which Godot listens for.

[✓] **Offline Mode**
- Have a local save approach first.
- This'll require a rewrite of the SaveManager to be less strcitly online vs local.
- This introduces sync bugs:
    - A timestamp is likely needed to be saved on the server.
    - Server shouldn't accept old saves.
    - Timestamps or version numbers.

[✓] **Boosts**
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
# Salt and Steel

## Table of Contents

- [About](#about)
- [Gameplay](#gameplay)
- [Development](#development)

## About

**Salt and Steel** is a personal video game project developed by me over approximately 4 months (for the first release). Starting when I was 16 years old.

It is a hybrid of **tower defense and deckbuilding**, with each towers being the cards. The players manage their resource, build their deck to survive the upcoming waves.

The game aesthetic features anime-inspired, painterly artstyle. The for gameplay, there are wave-based combats, purchasable items to upgrade your tower, and many other mechanics that would help increase the complexity of the game as you play *(trust me this is definitely true)*.

*All of the illustrations/artworks are done by **ME**. **No AI-generated assets were used in the project**. I only use AI to help me with learning the API, and writing repetitive logics.*

Originally, I want it to be a chess-based tower defense game with 1 month of development but since I have much more plans I decided to expand it, making it a much larger project that took 4 months to finish.


## Gameplay

![Gameplay](readmeassets/gameplayScreenShot1)

<p align="center">
 <i>Gameplay demonstration</i>
</p>

### The Deck

* The Deck is by far one of the most important mechanics in the game, yet it is pretty simple. You started with 8 cards (default). At the end of each wave, you get to choose a new card for your deck within the existed cards in the game. Each card is a tower, playing a card is the same thing as placing a tower down.
* Your hand will start with 4 cards by default. These cards are taken from the "deck pile". When a card is used or discarded, they will be put in the discard pile. When the deck pile is empty, **all** cards in the discard pile will move to the deck pile.
* The hand can be reshuffled with a economy cost.

### Economy 

* There is only **one** currency in the game: **Power**. Power is used in everything: placing towers, buying upgrade items, reshuffling the deck,...
* Power is gained through killing enemies and finishing a wave. The amount of Power you can gain can be changed by upgrade items.

### The Waves
* Each waves will summon enemies based on a preset pool. The wave will also last for a preset amount of time (except for the last one). When the time ends, the wave ends, even if there are still enemies remaining (those enemies will also stay here until they are defeated).
* Between waves are wave breaks. During a wave break, the player can choose new cards for their deck, have access to shops, prepare their defense. The game continue when the player pressed the start button.

### The Towers
* Towers are units that can be placed on the map, they attack enemies within their range. 
* Towers are inherently cards, you pick a tower (card) then decide where the tower would be placed. All towers have an attack range and a **placement range**, to place a unit, their placement range must not collide with any other existing towers.
* Towers attack the enemy that has progressed the furthest (further they are on the path the more likely for it to be attacked) within their range. Each units have different attack damage and attack interval.
* Units cannot be upgraded directly like traditional tower defense. Instead, during the wave break you can choose to buy items that act like an upgrades *(such as an item that increase damage dealt by 30% to all single target towers)*
* There are two type of towers as of current: **Single Target** and **Area Of Effect**. Single Target attacks one enemy at a time, while Area of Effect creates explosions that can hit multiple enemies.

### Tools
* **Tools**, *aka Items*, are upgrades that you can purchase at the shop with **Power**. There are not much to say about it since the effects are explained in the game, for example, the **Shattered Glass** tool increase all Single Target tower penetration stat by 5.0, **Saint Noel's Servant** slow enemies by 25% every time an enemy got attacked 3 times, etc.

### Enemies
* Enemies moves in a preset path until it reaches the end. Enemies can be damaged, they has an HP bar, and *defense* stat. Their moving speed are varied based on the type of the enemy. Enemies deal damage to the Base (damage dealt = their current HP) when they reach it (aka reaching the end). Enemies give **Power** when they die. It's as simple as that.

### Damage Formula
* Defense (for enemies) is a direct subtraction to the damage. If a tower deals 50 damage and the enemy has 30 defense, they tower will deal 20 damage. This number is capped at some point, if the damage cannot be reduced to be less than 10% of the original damage.
* Some towers can have Penetration stat, which reduces the enemy defense with this formula: **Defense = Defense * ( 1 - Penetration / 100)**. *For example, if an enemy has 100 defense and the tower has 30 penetration, then the enemy will only have 70 defense left.*

### Winning and Defeat Condition
* You lose when the **base hp** reach 0. You win when you clear all waves/enemies *(if the last enemy didn't get killed and reach the base, assuming that the base manage to tank it, it will still count as a win)*.

## Development 

*warning: since I'm new to game development and software engineering overall, I made quite a lot of questionable design choice so... yeah.*

The game is made in **Godot 4.x** with **GDscript** and **GDshader**. A large part of the game is data-driven architecture, using **Resource** to makes adding new stuffs easier without hard-coding.

### Game Manager:
- The game manager is actually less important than it sounds. The main thing that it does is initializing other systems and setting up the game. Originally I want it to play a bigger role but as development continued its job remained the same.

### Global:
- **Global.gd** is an Autoload script. It stores the current states of the game *(such as the "isWaveBreak" variable)*, various signals *(events)*, global variables *(Power, the currency)*, and some data stored with arrays *(wave data and tool, aka upgrades, list)*.

### PlayerStats:
- Don't ask why this was separated from Global idk what I was doing back then *(perhaps past me wanted to keep things clean and convenient). It's another Autoload script that contains variables like *powerIncreasePerKill*, which is just a quick and cheap way to make upgrades like *Gain 1 more Power from killing enemy* effortless because I just need to modify the variables in PlayerStats.

### Waves:
- The wave system is quite a... large system. It uses a data-driven architecture, meaning that creating a new wave doesn't require modifying the wave system itself. Instead, you simply create a new WaveEntry resource and define its SpawnEntrys. Each SpawnEntry represents a group of enemies along with their amount, delay, and spawn timing. The wave system then reads these resources and handles the rest automatically.
- Below is a demonstration of the system:
<p align="center"><img width="491" height="790" alt="image" src="https://github.com/user-attachments/assets/a26be846-5043-4e72-bf55-a3ab83fdcb69" /> </p>

- Handling the waves is actually not that hard. You just read the data, handle the SpawnEntries of a wave to the Spawning System. Using the delays, spawn timeline (*a lot of await get_tree.create_timer().timeout lmfao*),... to determine when to spawn an enemy and which enemy would show up. The wave ends when the duration of the wave runs out (*or when all enemies are killed if it's the **last** wave*). T




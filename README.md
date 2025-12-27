# FMP

Wiktoria Szramkowska

2106125



I really enjoy indie horror and a first person horror game was an obvious choice for my FMP, I have been building the skills I need for this project during the last 2 years of my Games Development course. There is a lot of different directions to go when it comes to indie horror, but I have a few ideas I am keen on implementing such as, a focus on atmospheric horror and an enemy AI which seems to behave intelligently. I first want to do some research to be better informed on what I really want to do with my game and the key mechanics I want to implement. 

## Research




I wanted to look at some video games to get inspiration for my game, specifically horror games that have one "big bad" enemy. Some games that come to mind included Alien: Isolation (Creative Assembly, 2014) and Amnesia: The Bunker (Frictional Games, 2023)
I will of course also be looking at Unreal documentation throughout my project, when I feel stuck with blueprints or anything else, as documentation is a good, official and up to date source.
For my core mechanics I will try to find video tutorials to help me.

#### Sources

#### Alien: Isolation

Alien: Isolation is a survival horror game published in 2014 and developed by Creative Assembly. I chose this game because of the anatagonist, the Xenomorph, which remains a benchmark in AI design over a decade later. The developers are able to create the illusion of an intellifent enemy that learns from the player through clever use of complex behaviour trees and a two tier system for the AI (aetos, 2025). I want to use what I have learned to create my own complex enemy that appears to learn from and adapt to the player. 

[How Does The Alien Work Off Camera Alien Isolation](https://youtu.be/MNMAduVsqhQ?si=Xm99RoZNNz3GOLOj)

<iframe width="560" height="315" src="https://www.youtube.com/embed/MNMAduVsqhQ?si=Xm99RoZNNz3GOLOj" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>


<br>


#### Unreal Documentation

Another source I will be regularly going to throughout my project is the Unreal Documentation as I believe it has some of the most accurate and up to date information. There are multiple that I will be using depending on the specific mechanics I am trying to implement, one such documentation is the AI Perception system (AI Perception in Unreal Engine | Unreal Engine 5.5 Documentation | Epic Developer Community, s.d.) which I used to help create my enemy AI.

Specifically I looked at AI Hearing and AI Sight. Hearing is handled by calling a 'Report Noise Event' which simulates the NPC hearing a sound. Sight alerts the NPC when player or an object enters the sight radius. 

I will also be using Behaviour Trees to manage the behaviour of my enemy AI. Although I have made games in Unreal Engine before, I actually have not used Behaviour Trees before so I will be frequently referring to documentation.

I started with learning the basics by reading the Quick Start Guide. (Behavior Tree in Unreal Engine - Quick Start Guide | Unreal Engine 5.7 Documentation | Epic Developer Community, s.d.) which explains how to create an enemy AI in Unreal Engine that patrols the level, detects the player using AI Perception, and switches to chasing them when they are seen. It covers setting up an AI Controller, Blackboard, and Behavior Tree with tasks for patrolling and chasing, using decorators to control state changes based on line of sight. When the AI loses sight of the player for a set time, it stops chasing and returns to patrolling, demonstrating a complete, reactive AI loop built with Blueprints.

Overall I think documentation is incredibly useful and as it is written on the official site, the information is incredibly accurate and is updated frequently. 

<br>

#### A survey of Behavior Trees in robotics and AI

I looked at academic papers, specifically about Behaviour trees to understand the underlying structure, strengths and limitations of Behaviour Trees. *A Survey of Behavior Trees in Robotics and AI* provided me with a strong academic foundation on understanding Behaviour Trees beyond engine-specific tutorials. The paper covers behavior tree theory, comparisons with other AI approaches such as finite state machines, and practical applications, making it particularly valuable for implementing complex AI behaviour correctly (Iovino et al., 2022). 

The source is reliable because it is written by established researchers and based on peer-reviewed academic work, providing a strong theoretical foundation for behaviour trees that are still widely used in Unreal Engine. However, it may be slightly outdated, as it does not cover recent engine-specific features or workflows, reflecting how quickly game technology evolves.





## Implementation




#### Planning 

My first goal is to make a prototype which can prove my game idea will work and is executable. I set out a few simple goals to achieve in this stage including a simplified version of the final AI (detects sound, sees player, chases player, patrols), and a working light system. These cover the core mechanics in my game. Other features such as player health and damage, crouching and sprinting, I have already done in previous projects so I am confident I will be able to implement them. 

Since avoiding my enemy AI will be a key mechanic in the game, I gave it a bit more attention during the planning phase. I split my goals into three parts to make them more manageable. The first stage of my Ai is to get it “alive” quickly with a simple patrol loop and perception-driven investigation. The monster reacts to sound and sight, checks the player’s last known location, and returns to patrol, creating a basic but readable hunt loop.

The second stage will increase believability by adding variability and tactics: EQS-driven search points, randomized patrols, and expanding investigation patterns. The monster can stalk, ambush, and pace itself, making searches feel emergent rather than scripted.

The third stage is to elevate the AI to a systemic predator using utility-based decision-making, long-term memory, and adaptive learning. The monster shapes the environment, anticipates player habits, controls territory, and optimizes performance so it feels intelligent, unpredictable, and oppressive rather than omniscient.

#### Health and Damage System 


<br>

#### Enemy AI 

My enemy is a core part of the game, most of the tense atmosphere will come from the fact the player is stuck in the house with this monster. I want to build a strong foundation for my enemy before diving into more complex features, so for the prototype I completed stage one of my plan for the AI.

The AI prototype was brought to life with a monster that patrols the house, reacts to sound and light, and hunts the player if its aggression grows too high—laying the foundation for an Alien-Isolation-style intelligent monster. The implementation involved creating a monster pawn with movement and perception components, an AI controller with a blackboard, and a behavior tree defining Patrol → Investigate → Hunt logic. Perception events update the blackboard, while light triggers increase aggression, causing more aggressive hunting behavior. After tuning patrol points, wait times, and sensory ranges, the monster exhibits basic but believable sensory-driven behavior, giving a solid base for more advanced AI in later stages.


<br>

#### Building the map

Since this is just a prototype I did not put a lot of focus on the map, however I thought it was important to do a bit of research on horror game maps and how they are built to create a terrifying atmosphere. 

I looked at Resident Evil 7: Biohazard (Capcom, 2017) because it was set in a house and aimed to invoke a sense of claustraphobia, which is something I wanted for my game. The game uses tight, interconnected spaces with limited visibility, forcing the player into close encounters and reducing their sense of control. Its looping layout and narrow corridors make it easy to feel lost or trapped, while blocked paths and locked doors constantly restrict movement. The confined environment, combined with strong sound design and minimal safe areas, keeps tension high and makes the player feel vulnerable throughout exploration.

Although this isn't the final map, I did build a small version with lots of rooms and long corridors which might not make sense in real life, but provide oppurtunities for tension and possible jumpscares in my game. 

<br>


#### Menus 

I created a simple Main Menu 

#### Feedback
I asked family, friends and colleagues to test out my game and give me their feedback. 

Key points from feedback:
- Game is scary, when the enemy is near there is a good level of tension
- Enemy ai could be more advanced e.g. the enemy can hear the player
- Lighting looks good and effective for the genre
- Once you find the key and escape, there is not much incentive to play again as you know where the key is so the game feels easier
- Map is good, not too big but still able to get away from the enemy
- Menus could look more interesting
- There are no instructions for what to do or how to play 

At this point I had limited time left to polish my project so I picked a couple points that I thought were very important and would greatly improve my game, but were still doable within the remaining time frame.

"No incentive to replay"
I wanted my game to be enjoyable for multiple runs and not just a one shot as that might mean the player doesn't even see the entire environment or potentially might not even meet the enemy if very lucky. To solve this issue I decided I would spawn my key in a random location from a set of predetermined locations. This means finding the key is not enough, you actually have to escape as well because on your next run it might be in a different location. It also encourages exploration.

"No instructions"
I think players can get easily frustrated when the objective of the game is not clear. I do not want players to get discouraged and drop my game so I decided to add a simple quest style bar in the top right which would direct the player. In addition I would add a message to the door saying something like "Press E to open" to make the controls of the game more obvious.

#### Randomly Spawning Key
I found a video by RubaDev on how to randomize actor spawn locations and adapted this to my blueprints in order to get different spawn locations for my key each time the level starts. 

- Set 5 target points where I wanted my key to spawn. I didn't want completely random spawn points as I wanted the locaction of the key to be fair and to make sense within the environment.
- Referenced these target points in my level blueprint and put them in an array.
- Got the locations and randomised them using 'random integer in range'
- Spawned the key

<iframe src="https://blueprintue.com/render/gfmawe9q/" scrolling="no" allowfullscreen></iframe>

*Figure 17. blueprints for spawning key in random locations*

#### 'Quest' bar
- I created a widget with a small quest bar in the top right of the screen. I added this to viewport from the BP_Key blueprint.
- Initially set to 'find the key'
- Upon player picking up the key I set the text to 'Escape' 

<iframe src="https://blueprintue.com/render/nc8-esjh/" scrolling="no" allowfullscreen></iframe>

*Figure 18. blueprints for adding the quest bar to viewport and setting the text after picking up ley*

#### Press 'E' prompt on door
- I made a widget and attached it to my door blueprint
- I made the widget visible when the player was within the doors collision box.

<iframe src="https://blueprintue.com/render/kk4k8d5g/" scrolling="no" allowfullscreen></iframe>

*Figure 19. blueprints for interaction prompt*

<br>

### Did you have any technical difficulties? If so, what were they and did you manage to overcome them?

- Did you have any issues completing the task? How did you overcome them?

##### Door
- opened too quick so I used a lerp node instead of setting my rotation inside of my door timeline 
- only set relative rotation
- doors were opening the opposite way so I added a multiply by -1 to the right door

##### Interact prompt
- was too low down and player couldn't see it so i changed the 'space' to world instead of screen as my message doesnt need to appear in a 360 around the door
- text was always shown so i had to set the initial visibility to off

##### Enemy sounds
- footsteps did not work
- fixed them by adding the play sound to my enemy walking and running animation, playing the sound when the foot was down
- zombie breathing didn't work unless the player spawned within its radius, and wouldnt restart if the player left and returned to the radius
- fixed this by checking play when silent

##### Github
- I had multiple difficulties with using github. Although I have used it for my previous tasks, this unit is the first time I have used github.
- When I downloaded my Medieval Dungeon Asset Pack I was unable to commit and push my changes. To fix this I downloaded git LFS. However that still did not work so I ended up deleting assets I did not need so I was able to commit and push.
- Despite having a .gitignore, whenever I made a build I could not commit my changes in github. I created a folder outside of the github repository, on my desktop, to fix this. However this still did not work so I had to manually delete the build folders within my repository. I also had to discard changes in the commit that were over 100mb, despite having git lfs set up.
- In future projects I will set up git lfs at the start and will also double check my .gitignore is set up correctly. This will hopefully prevent these problems from happening.


## Outcome





## Critical Reflection







## Bibliography

aetos (2025) The Illusion of Intelligence: A Technical Breakdown of Alien: Isolation’s AI. At: https://medium.com/@aetosdios27/the-illusion-of-intelligence-a-technical-breakdown-of-alien-isolations-ai-b2d7c9927d02 (Accessed  11/12/2025).

How Does The Alien Work Off Camera Alien Isolation (2023) Directed by Slippy Slides. At: https://www.youtube.com/watch?v=MNMAduVsqhQ (Accessed  11/12/2025).

Thompson, T. (2025) Revisiting the AI of Alien: Isolation. At: https://www.aiandgames.com/p/revisiting-alien-isolation (Accessed  11/12/2025).

Alien: Isolation - The Retrospective | AI and Games (2025) Directed by AI and Games. At: https://www.youtube.com/watch?v=LeIkEoHglQQ (Accessed  11/12/2025).

Behavior Tree in Unreal Engine - Quick Start Guide | Unreal Engine 5.7 Documentation | Epic Developer Community (s.d.) At: https://dev.epicgames.com/documentation/en-us/unreal-engine/behavior-tree-in-unreal-engine---quick-start-guide (Accessed  27/12/2025).

Iovino, M., Scukins, E., Styrud, J., Ögren, P. and Smith, C. (2022) 'A survey of Behavior Trees in robotics and AI' In: Robotics and Autonomous Systems 154 p.104096.





## Declared Assets


Used to assist in finding and summarising research material:
Chat GPT

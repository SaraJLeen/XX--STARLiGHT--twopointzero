local t = Def.ActorFrame{};

local function GetMWGroupDesc(song,so,mw)
	if not mw then return "" end
	if mw:GetSelectedType() == 'WheelItemDataType_Random' then
		return "Randomizes the order of the music wheel and then spins it, selecting whatever song it stops on."
	elseif mw:GetSelectedType() =='WheelItemDataType_Roulette' then
		return "Spin the music wheel in the order it's currently in, selecting whatever song it stops on."
	elseif mw:GetSelectedType() =='WheelItemDataType_Custom' then
		return "Nonstop Mode and Challenge Mode allow players to play several songs in succession, in the order laid out in predefined courses.\n\nThese courses are made to challenge players and for score attacking purposes, often themed after specific aspects of songs or their genres."
	elseif mw:GetSelectedType() == 'WheelItemDataType_Section' then
		if mw:GetSelectedSection() == "01 - DDR 1st" then
			return "Released September 26th, 1998\nDance Dance Revolution, also known as Dancing Stage in Europe, is a genre-defining rhythm game where players must use their feet instead of their hands.\n\nAlthough it was the second entry of Konami's Bemani series, DDR quickly became the most popular and well-known.\n\nDDR draws its music from a mix of Konami original songs and songs from the famous Dancemania series of licensed dance music albums released by Toshiba EMI.\n\nThe first iteration introduced characters Afro, Lady, Konsento:01, and Oshare-Zukin, with difficulties Basic and Another.\n\nAn Internet Ranking version would be released in November, adding Maniac difficulty as the third tier."
		elseif mw:GetSelectedSection() == "02 - DDR 2ndMIX" then
			return "Released January 29th, 1999\nThe sequel to DDR more than doubled the size of the song list while keeping every song from the original.\n\nIntroduced 12th and 16th notes, as well as characters Dread, Janet, Konsento:02, and Kaeru-Zukin. Also finally allowed multiplayer on mismatched difficulties, and added the Random function.\n\nAn enhanced Link Version was released on April 28th, bringing PS1 Memory Card support, as well as 5 additional songs.\n\nAlso released were two Club Versions with Beatmania IIDX connectivity, allowing players of IIDX and DDR to play IIDX music together in sync. (Their songs are in another group below.)"
		elseif mw:GetSelectedSection() == "03 - DDR 3rdMIX" then
			return "Released October 30th, 1999\nThe third DDR game came with a brand-new song list.\n\nIntroduced Emi, Rage, Boldo, Tracy, Astro, Charmy, Konsento:03, and Devil-Zukin as playable characters, as well as 9-foot difficulty songs per the old scale.\n\nManiac difficulty was renamed to SSR (Step Step Revolution), playable only as a separate game by entering a code on the title screen. As a result of this change, Doubles was playable in the third difficulty for the first time. Entering the code incorrectly would actually change the game into a fully-playable version of 2ndMIX instead!\n\nTwo Korean versions were released, with 7 and 9 additional Korean songs respectively. On June 21st, a Plus upgrade was released, adding 17 new songs, including all 7 of the additional songs from Korean Version 1."
		elseif mw:GetSelectedSection() == "04 - DDR 4thMIX" then
			return "Released August 24th, 2000\nBoasting 49 new songs and discarding the jukebox-style music select for a card-based one, 4thMIX also included almost every song from prior mixes.\n\nIntroduced Ni-Na, Izam, Yuni, Akira, Johnny, Jenny, Robo 2000, and Maid-Zukin as playable characters.\n\nAnother difficulty was renamed to Trick, while Maniac returned to its original name.\n\nA Plus version was released on December 28th, adding several new songs and unlocking all of the previously hidden songs by default."
		elseif mw:GetSelectedSection() == "05 - DDR 5thMIX" then
			return "Released March 27th, 2001\nThe fifth mainline DDR game brought DDR into 60 FPS and introduced the series' first music select wheel.\n\nIntroduced the characters Alice, Baby-Lon, Maho, Alice, Robo 2001, and Princess-Zukin, along with secret characters Naoki, U1, N.M.R, and 2MB.\n\nAlso new were several \"Long Version\" songs, at twice the length of a usual stage. This feature ended up being short-lived, however, and never returned to DDR officially.\n\nIt even introduced the AAA rating for perfect play!\n\nThe end of an era, this was the last DDR on pure PS1 hardware, and the last to feature dancing playable characters until SuperNOVA in 2006."
		elseif mw:GetSelectedSection() == "06 - DDR MAX" then
			return "Released October 19th, 2001\nDropping the classic naming scheme, DDRMAX was to be roughly the kind of transition for DDR as IIDX had been for Beatmania. It had 42 new songs, NO returning songs, and an iconic brand-new announcer, Londell \"Taz\" Hicks.\n\nIt replaced the scripted BG animations and dancers with FMVs played from a DVD, and ditched all foot-based ratings in favor of a brand-new feature known as the Groove Radar to instead indicate difficulty through specific aspects of each song. Difficulties became Light, Standard, and Heavy.\n\nIt also added an in-game options menu with numerous modifiers that players would soon become accustomed to using, and the ability to sort the song wheel.\n\nIntroduced the series' first top-tier Extra Stage, MAX 300, as well as the now-omnipresent Freeze Arrows."
		elseif mw:GetSelectedSection() == "07 - DDR MAX2" then
			return "Released March 27th, 2002\nMAX2 backtracked on some of MAX's decisions, bringing back numerous songs from previous mixes, as well as restoring foot difficulty ratings with a new maximum of 10. The Groove Radar could now co-exist alongside the classic ratings system.\n\nFurthermore, MAX2 introduced a brand-new mode known as Challenge Mode, where players face courses of 5 or more songs in a row while being allowed only 3 misses or they will Game Over.\n\nThis game's Extra Stage boss song is MAXX UNLIMITED, the first-ever sequel to MAX 300, although many would follow."
		elseif mw:GetSelectedSection() == "08 - DDR EXTREME" then
			return "Released December 25th, 2002\nAppearing to be a heartful final hurrah for DDR, this game was the last arcade DDR title for several years.\n\nThis game introduced Beginner difficulty, and crammed more songs to it than any prior game, a whopping 240, resulting in an audio quality dip due to the amount of space taken up on the DVD.\n\nNonstop Mode returned in place of Challenge Mode, but Challenge difficulty was added for some songs, including those that had only appeared in Challenge Mode in MAX2.\n\nThis game's Extra Stage boss song is The legend of MAX, although an additional boss song was added for play only on the final stage, known as PARANOiA survivor MAX."
		elseif mw:GetSelectedSection() == "09 - DDR SuperNOVA" then
			return "Released July 12th, 2006\nRunning on brand-new hardware, SuperNOVA was a much-anticipated return for the series, and even got a worldwide release.\n\nWith e-Amusement network features, players could finally save their scores and other data without need for a PS1 Memory Card.\n\nAdditionally, dancing characters finally returned, with new additions Disco, Gus, Julio, and Ruby joining the lineup, as well as obligatory new versions of Konsento and Zukin, Konsento Be-fu and Robo-Zukin. Dancing characters now occupied new 3D dance stages instead of dancing over scripted background animations.\n\nDifficulties became Basic, Difficult, and Expert, the same ones that are still in use today."
		elseif mw:GetSelectedSection() == "10 - DDR SuperNOVA2" then
			return "Released August 22nd, 2007\nAnother worldwide release, SuperNOVA2 introduced Marvelous judgments for normal gameplay, which had previously only appeared in Nonstop Mode and Challenge Mode.\n\nThis game featured a wider variety of licensed music, no longer beholden to Dancemania as Konami had chosen to end their contract with Toshiba EMI.\n\nThe game featured several special e-Amusement events during its lifetime, and many different possible Extra Stage songs were also added over time.\n\nFor the first time, none of the boss songs were an arrangement of the MAX series of songs.\n\nOnly 2 new characters, Konsento Kyo-fu and Dark-Zukin."
		elseif mw:GetSelectedSection() == "11 - DDR X" then
			return "Released December 24th, 2008\nSeries director NAOKI stepped down from his role, heralding a divisive start to a new era of DDR.\n\nDDR X brought the series to PC-based hardware, bringing the graphics up from 480p to 720p widescreen.\n\nA new arrow type known as Shock Arrows was introduced, which players must avoid stepping on, and Justin and Wil-Dog from Ozomatli replaced Taz as the announcers.\n\nNew characters introduced were Bonnie and Zero, as well as Louis-Konsento III and Queen-Zukin, and dancing characters received predefined dance routines based on which song is being played.\n\nThis is the game that introduced the modern 1-20 difficulty scale, doing away with the classic foot-based ratings."
		elseif mw:GetSelectedSection() == "12 - DDR X2" then
			return "Released July 7th, 2010\nIntroduced a new mode for beginners known as Happy Mode, trimming away all of the options to give them a simpler experience.\n\nThis game also abandoned the music select wheel in favor of a cover flow type of music select.\n\nThe game's Extra Stage system was completely overhauled to encourage the player to choose from a variety of specific boss songs.\n\nNew characters introduced were Rinon and Rena, and new variants Victory Konsento and Geisha-Zukin appeared as well."
		elseif mw:GetSelectedSection() == "13 - DDR X3 vs 2ndMIX" then
			return "Released November 16th, 2011\nIn this game, players must get a special kind of points known as Stars if they want to reach the Extra Stage.\n\nA solid but unremarkable sequel on its own, players soon discovered that the 2ndMIX code from 3rdMIX was not only surprisingly functional in this game, but gave them access to a complete widescreen and 60 FPS HD remaster of 2ndMIX.\n\nThis 2ndMIX remaster boasts all of its quirks, even infamously misspelled text and the old foot-based difficulty scale.\n\nAfter the player has played enough, they unlock remixes of certain 2ndMIX songs in X3, as well as two brand-new Extra Stage boss songs in 2ndMIX itself."
		elseif mw:GetSelectedSection() == "14 - DDR 2013 ~ 2014" then
			return "Released March 14th, 2013 & May 12th, 2014\nThis release dropped all subtitles, simply retitling as Dance Dance Revolution. Surprisingly, this is actually the eighth unique title to go by that name.\n\nIt implemented colored combo counters based on your lowest judgment, as well as a splash when you get a Full Combo.\n\nIn 2014, it received an interface overhaul, including clear lamps similar to Beatmania IIDX, and a full complement of new songs, but the name of the game did not change.\n\nAs well, NAOKI finalized his departure from Konami after the 2013 release but before the 2014 upgrade."
		elseif mw:GetSelectedSection() == "15 - DDR A" then
			return "Released March 30th, 2016\nPronounced \"Ace\". The interface received another overhaul, and e-Amusement was supported for the first time ever in English versions of the game.\n\nSeveral western pop songs were added to the game in celebration of its return to English-speaking countries, and the embedded OS was upgraded from Windows XP to Windows 7.\n\nWith the release of DDR A, DDR began to include more anime & TV songs, as well as songs from the Touhou series."
		elseif mw:GetSelectedSection() == "16 - DDR A20" then
			return "Released March 20th, 2019\nPrnounced \"Ace Two-Oh\". Made to celebrate DDR's 20th anniversary, A20 received two different releases: a normal \"blue\" release and a special \"gold\" release with a new gold cabinet. Even the interfaces differed in color between the two versions.\n\nGold cabinets had access extra modes and songs compared to the blue cabinets, and this pattern would continue for later mixes.\n\nReceived a Plus version on July 1st, 2020, adding several new songs, as well as a new mode to check the player's skill level."
		elseif mw:GetSelectedSection() == "17 - DDR A3" then
			return "Released March 17th, 2022\nImplemented the ability to toggle between Single Play and Double Play on the music select screen.\n\nA Konami Station version of this game was released for Windows PCs, known as DDR GRAND PRIX. Notably, some paid or earned unlocks carry over between the two versions of the game.\n\nLargely an unremarkable new version with no major new features, and at launch, it didn't even have any new licensed music whatsoever.\n\nIt brought very few new songs at first, with most of its new content coming through the many e-Amusement events that have been enabled for it over time."
		elseif mw:GetSelectedSection() == "50 - DDR SuperNOVA3" then
			return "An in-depth fan-made song pack by Midflight Digital, DDR SuperNOVA3 asks the question, \"What if Konami were to create a sequel to SuperNOVA2?\"\n\nIt is comprised of remixes, hits from other Bemani games, and of course, several popular hit songs.\n\nSuperNOVA3 is widely regarded as one of the best song packs ever made for DDR."
		elseif mw:GetSelectedSection() == "51 - DDR XX" then
			return "An in-depth fan-made song pack by Midflight Digital, DDR XX STARLiGHT attempts to make real what they would imagine a new entry in the DDR X series to be like.\n\nIt is comprised of remixes, hits from other Bemani games, and of course, several popular hit songs.\n\nLike its predecessor, DDR XX is widely regarded as one of the best song packs ever made for DDR."
		elseif mw:GetSelectedSection() == "Ace of Arrows" then
			return "Ace of Arrows, formerly known as Ace of Hearts, is a stepchart maker who was active from July 2008 to August of 2021, making numerous song packs for In The Groove during that time.\n\nTheir charts make heavy use of ITG features, such as Mines and Roll Arrows, and are generally made with the same kind of approach to charting as ITG official songs.\n\nThe quality can vary wildly, and there are no bespoke Double Play charts, but Ace of Arrows has charted songs from numerous sources, including anime, video games, Bemani, and popular music of Japan and the west alike.\n\nThere is something for everyone in this folder."
		elseif mw:GetSelectedSection() == "Dancing Stage Collection" then
			return "When Dance Dance Revolution was localized for European audiences, it became known as Dancing Stage, a title also used for a small few DDR spinoffs in Japan.\n\nOne of the first Dancing Stage games of note was Dancing Stage EuroMIX, a game based on DDR 3rdMIX with 8 pop hits licensed from Universal Music.\n\nSince then, numerous titles have been added to this particular branch of the DDR family, all of them with their own unique added songs.\n\nThis folder contains all of the songs that have called Dancing Stage their one and only home over the years."
		elseif mw:GetSelectedSection() == "DDR Club Version" then
			return "Released April 21st, 1999 & July 27th, 1999\nDDR CLUB VERSiON is a pair of unique versions of 2ndMIX that can be connected with a Beatmania IIDX substream cabinet.\n\nIf the IIDX cabinet is not active or the link is done improperly, these games would load as DDR 2ndMIX Link Version instead.\n\nWhen both cabinets are active, DDR players will play along to the songs the IIDX players select, complete with every mistake they make. Most of these songs never made it to any mainline DDR title.\n\nUnfortunately, it proved less popular than hoped, and unlike GuitarFreak and DrumMania, no linked version of DDR and IIDX would ever be produced again."
		elseif mw:GetSelectedSection() == "DDR Disney" then
			return "Dancing Stage featuring Disney's RAVE was released November 30th, 2000. This game boasted 25 songs from Disney or popular music, each with a related Disney character that would dance or DJ along to your gameplay. A versus play feature was included, known as Dance Magic, which would return as the Battle Mode of DDR SuperNOVA in 2006.\n\nDDR Disney Channel EDITION was released January 8th, 2008 for PS2, containing 20 uncredited covers of Disney Channel songs. Each song has Disney Channel show characters instead of ordinary DDR dancers, and various outfits can be unlocked for them. It was known for its exceptionally bad judgment timing.\n\nDDR Disney Grooves was released April 2nd, 2009 for the Wii. Developed out of house, it contained a whopping 40 covers of Disney songs, but merely recycled the rest of its interface and gameplay from DDR HOTTEST PARTY."
		elseif mw:GetSelectedSection() == "DDR GRAND PRIX" then
			return "Released November 8th, 2021\nThis is a PC Konami Station title with a subscription-based fee structure to play.\n\nBased largely on DDR A20 Plus and later DDR A3, GRAND PRIX keeps parity with the arcade version and allows you to effectively play the arcade version as a bonus mode if you have enough tickets.\n\nComes with only a handful of songs by default, but several music packs can be purchased to increase its song list dramatically.\n\nSome progress and unlocks are shared with the arcade version based on the player's e-Amusement pass, and some songs remain thus-far exclusive to GRAND PRIX."
		elseif mw:GetSelectedSection() == "DDR HOTTEST PARTY" then
			return "HOTTEST PARTY was the flagship series of DDR for the Nintendo Wii.\n\nMainly focused on gimmicks, it contained many unusual arrow types that could only be hit using the Wii Remote and Nunchuk while still otherwise utilizing a Dance Pad. Even so, all of these gimmicks could easily be disabled, revealing ordinary DDR stepcharts, all of which have been included here.\n\nNo characters from the mainline DDR games returned, instead being replaced by characters entirely unique to this specific subseries."
		elseif mw:GetSelectedSection() == "DDR Mario Mix" then
			return "Released July 14th, 2005\nDance Dance Revolution MARIO MIX is a licensed title in the DDR series starring Mario characters.\n\nDeveloped by Hudson for the Nintendo GameCube, it runs in the same engine as Mario Party 6, and introduces many gameplay gimmicks that would later be refined and reused in the DDR HOTTEST PARTY series.\n\nThe song list is comprised of various arrangements of Mario series songs, although none of them are credited, so who arranged each track is largely unknown.\n\nAdditionally, none of the songs displayed any sort of difficulty rating, leading to a situation in which the difficulty ratings had to be extrapolated from unused data instead."
		elseif mw:GetSelectedSection() == "DDR Misc" then
			return "Over the years, numerous smaller DDR titles were released that do not fall under any larger banner.\n\nSome noteworthy entries were Dance Dance Revolution KIDS, Oha Star Dance Dance Revolution, Dancing Stage featuring Dreams Come True, and Dancing Stage featuring TRUE KiSS DESTiNATiON.\n\nThere were also multiple DDR mobile games, and a couple of songs from those didn't make it anywhere else.\n\nOne of the most unique individual spinoffs was Tokimeki Memorial 2 Substories: Dancing Summer Vacation for PS1, a dating sim in which the player romanced women from Tokimeki Memorial 2 while occasionally playing Dance Dance Revolution. It included its own version of DDR known as Dance Dance Revolution Tokimeki Mix."
		elseif mw:GetSelectedSection() == "DDR PS2" then
			return "Although most DDR games for the PlayStation 2 were based upon arcade titles, several later titles were released that did not fit neatly into any of them, instead boasting their own unique interface, theme, and song list.\n\nSongs from DDR EXTREME2, DDR STRIKE, DDR FESTIVAL, and DDR STRIKE are collected here, among others.\n\nConsidered to be somewhat lower-quality games than those based on arcade titles, they nevertheless included many quality licensed songs that would not appear anywhere else in the series."
		elseif mw:GetSelectedSection() == "DDR PS3" then
			return "Released November 16th, 2010\nAlso known as DDR New Moves or DDR 2010, this game was released exclusively on PlayStation 3 until a later port brought it to the Xbox 360.\n\nDeveloped by Genki, the developers of Tokyo Xtreme Racer.\n\nIt has many quirks, including a very unusual and unique list of licensed music, and requiring players to unlock Challenge difficulty for each song by beating Expert difficulty first.\n\nIt also included a mechanic known as the Groove Trigger, which works similarly to Star Power from Guitar Hero and Rock Band.\n\nRather infamously, Dance Pads made for this game were not compatible with PC simulators, as there was absolutely no way to press opposing arrows with their DirectInput drivers."
		elseif mw:GetSelectedSection() == "DDR Solo" then
			return "Released August 19th, 1999 & December 16th, 1999\nDDR Solo BASS MIX and DDR Solo 2000 were two unique versions of DDR that added up-left and up-right corner arrows to the dance pad, while cutting the second player out of the equation.\n\nThese games achieved 60 FPS before 5thMIX, and had completely unique licenses, few of which would make it to the mainline DDR series.\n\nIt also boasted an unknown female announcer who was unique to this subseries.\n\nThere are no dancers, and some songs have FMV background animations included, long predating DDRMAX.\n\n4thMIX could also be installed on Solo cabinets, complete with Solo charts, but it otherwise ceased to exist afterwards."
		elseif mw:GetSelectedSection() == "DDR ULTRAMIX" then
			return "ULTRAMIX was the flaship series of DDR for the Xbox.\n\nLargely unique among DDR titles, they have a much more western vibe and aesthetic to them in general.\n\nEven the dancing characters were redesigned in ways that appeal more to western audiences, such as skimpier clothing and the addition of jiggle physics.\n\nEach game in the series had 4-player support as well as online gameplay, and several DLC music packs could be purchased for each title.\n\nMany of the Bemani crossover songs and remixes from the Ultramix series would later make it over to the mainline DDR series.\n\nFirst overseas DDR series to receive Dancemania licenses."
		elseif mw:GetSelectedSection() == "DDR UNIVERSE" then
			return "UNIVERSE was the flagship series of DDR for the Xbox 360.\n\nLargely similar to the ULTRAMIX series, it did however begin to return more to the original feeling of Japanese DDR in terms of aesthetic.\n\nUNIVERSE2 and UNIVERSE3 were developed by Hudson Soft, similar to DDR MARIO MIX.\n\nLike ULTRAMIX, UNIVERSE thrived on its DLC, receiving numerous music packs players could purchase.\n\nUNIVERSE3 received a Chinese release with exclusive songs that weren't in any other version."
		elseif mw:GetSelectedSection() == "DDR Wii" then
			return "Although HOTTEST PARTY was the flagship series, several other DDR titles were released for the Nintendo Wii.\n\nThis includes a fitness title, a game called Dance Dance Revolution II, and even a licensed Winx Club game.\n\nThis folder collects the various songs from all of the assorted Wii DDR titles into one place."
		elseif mw:GetSelectedSection() == "Gradi and Galamoth" then
			return "Gradi and Galamoth are stepchart creators known for their very successful collaborative pack, Ethereal Rebellion, which was released in August of 2009.\n\n11 years later, they got back together and created several more high-quality packs, after the beginning of the COVID-19 pandemic left them with little else to do.\n\nAll of their assorted packs are collected in this folder, with a variety of popular music and game music, among other things."
		elseif mw:GetSelectedSection() == "ITG 01 - 1" then
			return "Released August 30th, 2004\nIn the Groove is the first in a series of dance games based on DDR, running in the StepMania DDR simulator.\n\nIt was first created by Kyle Andrew Ward, also known as KaW, and his company Roxor Games.\n\nIn the Groove stands out for its unique mechanics, such as Roll Arrows and Mines, and its 3D arrow graphics which could be viewed at an angle instead of only from directly overhead.\n\nIn the Groove difficulty ratings were based on the stamina it takes to play a chart, rather than the difficulty of it, resulting in much different ratings than DDR.\n\nA PlayStation 2 port was released by RedOctane, and a sequel eventually came around as well."
		elseif mw:GetSelectedSection() == "ITG 02 - 2" then
			return "Released June 18th, 2005\nIn the Groove 2 included every song from the arcade and home versions of In the Groove, as well as 65 new songs.\n\nThe interface was mostly similar to the original but recolored, and the Novice difficulty was added, similar to DDR's Beginner difficulty.\n\nIt also received an official Pump it Up version, known as Pump it Up: In the Groove 2. Many of the team would move on to work on Pump it Up Pro and Infinity after this title.\n\nPlans for a sequel were tanked after a lawsuit from Konami ended in an out-of-court settlement, although In the Groove 3 would eventually be completed by dedicated fans."
		elseif mw:GetSelectedSection() == "ITG 03 - 3" then
			return "Unofficial fan-finished version of In the Groove 3, released in 2007.\n\nContains many of the songs that would have been in the official In the Groove 3, as well as many additions.\n\nA well-regarded community song pack."
		elseif mw:GetSelectedSection() == "ITG 04 - Rebirth" then
			return "Unofficial fan sequel pack to In the Groove, released in 2008.\n\nContains many songs from established In the Groove musicians and quality stepcharts made by experienced creators."
		elseif mw:GetSelectedSection() == "ITG 05 - Rebirth 2" then
			return "Unofficial fan sequel pack to In the Groove, released in 2011.\n\nLike its predecessor, it contains many songs from established In the Groove musicians and quality stepcharts made by experienced creators."
		elseif mw:GetSelectedSection() == "PIU 01 - 1st ~ Perf" then
			return "Released September 20th, 1999 ~ December 7th, 2000\nPump It Up is a series produced by Andamiro. While similar to DDR, it's also quite opposite: it uses the four corners and the center as its buttons.\n\nPump It Up consists primarily of K-Pop, with many original songs by Andamiro's in-house music group BanYa Productions.\n\nOver the years, other original producers have come onboard, such as Yahpp, DOIN, and MAX.\n\nTitles represented in this folder:\nPump It Up: The 1st Dance Floor\nPump It Up: The 2nd Dance Floor\nPump It Up The O.B.G: The 3rd Dance Floor\nPump It Up The O.B.G: The Season Evolution Dance Floor\nPump It Up: The Perfect Collection"
		elseif mw:GetSelectedSection() == "PIU 02 - Extra ~ PREX3" then
			return "Released January 20th, 2001 ~ October 4th, 2003\nPump It Up is a series produced by Andamiro. While similar to DDR, it's also quite opposite: it uses the four corners and the center as its buttons.\n\nPump It Up consists primarily of K-Pop, with many original songs by Andamiro's in-house music group BanYa Productions.\n\nOver the years, other original producers have come onboard, such as Yahpp, DOIN, and MAX.\n\nTitles represented in this folder:\nPump It Up Extra\nPump It Up The PREX: The International Dance Floor\nPump It Up The Rebirth: The 8th Dance Floor\nPump It Up The PREX 2\nPump It Up The PREX 3: The International 4th Dance Floor"
		elseif mw:GetSelectedSection() == "PIU 03 - Exceed ~ Zero" then
			return "Released April 2nd, 2004 ~ January 28th, 2006\nPump It Up is a series produced by Andamiro. While similar to DDR, it's also quite opposite: it uses the four corners and the center as its buttons.\n\nPump It Up consists primarily of K-Pop, with many original songs by Andamiro's in-house music group BanYa Productions.\n\nOver the years, other original producers have come onboard, such as Yahpp, DOIN, and MAX.\n\nTitles represented in this folder:\nPump It Up Exceed: The International 5th Dance Floor\nPump It Up Exceed 2: The International 6th Dance Floor\nPump It Up Zero: International 7th Dance Floor"
		elseif mw:GetSelectedSection() == "PIU 04 - NX ~ NX Absolute" then
			return "Released December 15th, 2006 ~ November 25th, 2008\nPump It Up is a series produced by Andamiro. While similar to DDR, it's also quite opposite: it uses the four corners and the center as its buttons.\n\nPump It Up consists primarily of K-Pop, with many original songs by Andamiro's in-house music group BanYa Productions.\n\nOver the years, other original producers have come onboard, such as Yahpp, DOIN, and MAX.\n\nTitles represented in this folder:\nPump It Up NX: New Xenesis\nPump It Up NX2: Next Xenesis\nPump It Up NX Absolute: International 10th Dance Floor"
		elseif mw:GetSelectedSection() == "PIU 05 - Fiesta ~ Fiesta 2" then
			return "Released March 6th, 2010 ~ November 24th, 2012\nPump It Up is a series produced by Andamiro. While similar to DDR, it's also quite opposite: it uses the four corners and the center as its buttons.\n\nPump It Up consists primarily of K-Pop, with many original songs by Andamiro's in-house music group BanYa Productions.\n\nOver the years, other original producers have come onboard, such as Yahpp, DOIN, and MAX.\n\nTitles represented in this folder:\nPump It Up 2010 Fiesta\nPump It Up 2011 Fiesta EX\nPump It Up 2013 Fiesta 2"
		elseif mw:GetSelectedSection() == "PIU 06 - Prime" then
			return "Released December 24th, 2014\nPump It Up Prime finally upgrades the series to HD, along with network functionality to save player scores and download update data.\n\nPrime had two interfaces, one for ordinary users, and one for serious players. Full Mode is unlocked by using an AM.PASS or through the use of a complex button code.\n\nAdditionally, Prime added a Rank Mode, with extremely harsh judgment timing and scoring.\n\nSeveral other modes were offered as well, such as Quest Mode.\n\nUsers could save their favorite songs and more through functionality on the PIUGame website."
		elseif mw:GetSelectedSection() == "PIU 07 - Prime 2" then
			return "Released December 12th, 2016\nPrime 2 brought over all of the features of Prime, with a slick new interface and several quality-of-life additions.\n\nA rival system was added, allowing you to register other players as your rivals and easily compare scores with them.\n\nAn auto-velocity system was also added, allowing you to control your BPM setting directly instead of only adjusting it with multipliers.\n\nThe interface was much more convenient and quick to navigate than Prime's."
		elseif mw:GetSelectedSection() == "PIU 08 - XX" then
			return "Released January 7th, 2019\nPronounced \"Double X\", XX is the 20th Anniversary Edition of Pump It Up.\n\nThe biggest addition in Pump It Up XX was an online matchmaking system, allowing you to compete against other players worldwide over the network, as long as you have an AM.PASS.\n\nIt also added an unlock system, allowing the unlock of new stepcharts for songs, as well as new titles for you to show off.\n\nPretty much every song was re-evaluated to make sure the difficulty level was set correctly, and all of the background videos were remastered."
		elseif mw:GetSelectedSection() == "PIU 50 - Pro ~ Pro 2" then
			return "Released August 2007 & February 2010\nUnlike other entries in the series, Pump It Up Pro was developed in the west by Kyle Andrew Ward, also known as KaW, and his development team that had previously made the In the Groove serise of games.\n\nRunning on a modified version of StepMania, the Pro games featured a much different interface from any other Pump it Up titles, with a vertical song list aligned to the middle of the screen.\n\nSince it was developed in StepMania, every chart has a credit to its author in the files, which is unusual for arcade rhythm games.\n\nPump it Up Pro was popular enough to get two sequels, Pump it Up Pro 2 and Pump it Up Infinity."
		elseif mw:GetSelectedSection() == "PIU 51 - Infinity" then
			return "Released January 2013\nAlthough developed by the Pump it Up Pro team using StepMania, Infinity sought to get a bit closer to the mainline Pump it Up series.\n\nIt boasted an HD display and all of the modes that were expected from Pump it Up as of Fiesta 2, and a mix of music from the west and from Andamiro alike.\n\nUnlike Pro, some of the Korean Andamiro staff were also involved directly in this title."
		elseif mw:GetSelectedSection() == "Sara's Classics" then
			return "Sara's collection of simfiles that she gathered for the DDR simulator Dance With Intensity from 2001 through 2011, from a wide variety of stepchart creators.\n\nA wide variety of music is presented in this folder, many of them possessing extremely high-difficulty Heavy or Challenge charts.\n\nThe quality of the songs provided varies wildly, but there's a very nostalgic feeling from the early 2000's in this folder."
		elseif mw:GetSelectedSection() == "SPEIRMIX" then
			return "Ben Speirs was a stepchart creator who created large packs known as Speirmix.\n\nFor the most part, his abilities were exceptional, and most of his packs had a very wide variety of songs and genres to choose from.\n\nYou can find huge amounts of popular music in his packs.\n\nAll of Speirmix 1 through 4 are collected in this folder."
		elseif mw:GetSelectedSection() == "SPEIRMIX GALAXY" then
			return "SPEIRMIX GALAXY is a megapack created entirely by Ben Speirs, the creator of the Speirmix series.\n\nThis pack emphasizes modern pop, with tons of bonus tracks, and was very clearly optimized for the ITG difficulty scale.\n\nNearly every song has a high-quality music video included as well.\n\nThere is definitely something for everyone in this folder."
		elseif mw:GetSelectedSection() == "SPEIRMIX VS" then
			return "SPEIRMIX VS is a series of music packs from Ben Speirs, the creator of the Speirmix series.\n\nThis folder contains these packs:\nBen Speirs' SPEIRMIX VS EuroVision\nBen Speirs' SPEIRMIX VS One Direction\nBen Speirs' SPEIRMIX VS Pump It Up (Vol.1)\n\nSadly, SPEIRMIX VS EuroVision 2013 seems to be lost in the mists of time.\n\nAs with other SPEIRMIX packs, all of the songs are fairly high-quality and the variety is pretty good."
		elseif mw:GetSelectedSection() == "Sudziosis" then
			return "Sudziosis is the main name of the various music packs made by stepchart creator sudzi781.\n\nAll of his packs are geared toward ITG players, with an overall similar vibe and difficulty compared to ITG.\n\nHe also released packs specifically for Doubles players, showing an interest in more versatility in play style than most fan step authors display.\n\nAll 5 Sudziosis packs are included in this folder, as well as his other packs: Power Metal Doubles, Rock Out!, Fun-Sized Doubles, Xi, and Sudzi's B-Sides."
		else
			return ""
		end
	end
	return ""
end

t[#t+1] = Def.ActorFrame {
	InitCommand=function(s) s:xy(20,424):visible(false) end,
	OnCommand=function(s) s:addy(-800):sleep(0.4):decelerate(0.5):addy(800) end,
	OffCommand=function(s) s:sleep(0.3):decelerate(0.5):addy(-800) end,
	CurrentSongChangedMessageCommand=function(s)
		s:finishtweening()
		s:queuecommand("Set")
		local song = GAMESTATE:GetCurrentSong();
		local so = GAMESTATE:GetSortOrder();
		local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
		local bt = s:GetChild("GroupDesc")
		s:visible(false)
		if not mw then return end
		if song then
			s:visible(false)
		elseif mw:GetSelectedType() == 'WheelItemDataType_Random' then
			s:visible(true)
		elseif mw:GetSelectedType() == 'WheelItemDataType_Roulette' then
			s:visible(true)
		elseif mw:GetSelectedType() == 'WheelItemDataType_Custom' then
			s:visible(true)
		elseif mw:GetSelectedType() == 'WheelItemDataType_Section' then
			if mw:GetSelectedSection() == "" then
				s:visible(false)
			else
				s:visible(false)
				if GetMWGroupDesc(song,so,mw) ~= "" then s:visible(true) end
			end
		else
			s:visible(false)
		end;
	end,
	Def.Sprite{
		Texture="GroupDescBack",
		SetCommand=function(self,params)
			self:finishtweening()
			self:align(0,0)
			self:xy(0,0)
		end;
	};
	Def.BitmapText{
		Font="_avenirnext lt pro bold/25px",
		Name="GroupDesc";
		InitCommand=function(self)
			self:align(0,0)
			self:diffuse(Color.White)
			self:strokecolor(Color.Black)
			self:xy(28,28)
			self:settext("lorum ipsum")
			self:maxwidth(744)
			self:maxheight(540)
			self:wrapwidthpixels(744)
		end;
		SetCommand=function(self,params)
			self:finishtweening()
			local song = GAMESTATE:GetCurrentSong();
			local so = GAMESTATE:GetSortOrder();
			local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
			self:settext("")
			if not mw then return end
			self:settext(GetMWGroupDesc(song,so,mw))
			self:align(0,0)
		end;
	};
};

return t;
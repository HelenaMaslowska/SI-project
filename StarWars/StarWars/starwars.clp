;;; ***************************
;;; * DEFTEMPLATES & DEFFACTS *
;;; ***************************

(deftemplate UI-state
   (slot id (default-dynamic (gensym*)))
   (slot display)
   (slot relation-asserted (default none))
   (slot response (default none))
   (multislot valid-answers)
   (slot state (default middle)))
   
(deftemplate state-list
   (slot current)
   (multislot sequence))
  
(deffacts startup
   (state-list))
   
;;;****************
;;;* STARTUP RULE *
;;;****************

(defrule system-banner ""

  =>
  
  (assert (UI-state (display WelcomeMessage)
                    (relation-asserted start)
                    (state initial)
                    (valid-answers)))
)

;;;***********
;;;* QUERIES *
;;;***********

(defrule ChoosePathQuery

	(logical (start))

   =>

   (assert (UI-state (display ChoosePathQuestion)
                     (relation-asserted ChoosePath)
                     (response Overworked)
                     (valid-answers Overworked GetOffRock)))
)

(defrule TravelFarQuery

	(logical (ChoosePath GetOffRock))

   =>

   (assert (UI-state (display TravelFarQuestion)
                     (relation-asserted TravelFar)
                     (response Yes)
                     (valid-answers Yes)))
)

(defrule Midi-ChlorianCountQuery

	(logical (ChoosePath GetOffRock))
	(logical (TravelFar Yes))

   =>

   (assert (UI-state (display Midi-ChlorianCountQuestion)
                     (relation-asserted Midi-ChlorianCount)
                     (response WhatMidi-chlorian)
                     (valid-answers WhatMidi-chlorian OffCharts)))
)

(defrule DontGetCockyQuery

	(logical (ChoosePath GetOffRock))
	(logical (TravelFar Yes))
	(logical (Midi-ChlorianCount OffCharts))

   =>

   (assert (UI-state (display DontGetCockyQuestion)
                     (relation-asserted DontGetCocky)))
)

(defrule SearchOrHideQuery

	(logical (ChoosePath GetOffRock))
	(logical (TravelFar Yes))
	(logical (Midi-ChlorianCount OffCharts))
	(logical (DontGetCocky))

   =>

   (assert (UI-state (display SearchOrHideQuestion)
                     (relation-asserted SearchOrHide)
					 (response Search)
                     (valid-answers Search)))
)

(defrule SearchOrScavengeQuery

	(logical (ChoosePath GetOffRock))
	(logical (TravelFar Yes))
	(logical (Midi-ChlorianCount OffCharts))
	(logical (DontGetCocky))
	(logical (SearchOrHide Search))

   =>

   (assert (UI-state (display SearchOrScavengeQuestion)
                     (relation-asserted SearchOrScavenge)
					 (response Search)
                     (valid-answers Search Scavenge)))
)

(defrule ForAdventureQuery

	(logical (ChoosePath GetOffRock))
	(logical (TravelFar Yes))
	(logical (Midi-ChlorianCount OffCharts))
	(logical (DontGetCocky))
	(logical (SearchOrHide Search))
	(logical (SearchOrScavenge Search))

   =>

   (assert (UI-state (display ForAdventureQuestion)
                     (relation-asserted ForAdventure)
					 (response Yes)
                     (valid-answers Yes AdventureNo)))
)

(defrule BlueMilkQuery

	(logical (ChoosePath GetOffRock))
	(logical (TravelFar Yes))
	(logical (Midi-ChlorianCount OffCharts))
	(logical (DontGetCocky))
	(logical (SearchOrHide Search))
	(logical (SearchOrScavenge Search))
	(logical (ForAdventure Yes))

   =>

   (assert (UI-state (display BlueMilkQuestion)
                     (relation-asserted BlueMilk)
					 (response Warm)
                     (valid-answers Warm Cold)))
)

(defrule TrapQuery

	(logical (ChoosePath GetOffRock))
	(logical (TravelFar Yes))
	(logical (Midi-ChlorianCount OffCharts))
	(logical (DontGetCocky))
	(logical (SearchOrHide Search))
	(logical (SearchOrScavenge Search))
	(logical (ForAdventure Yes))
	(logical (BlueMilk Warm))

   =>

   (assert (UI-state (display TrapQuestion)
                     (relation-asserted Trap))))
)

(defrule TauntaunQuery

	(logical (ChoosePath GetOffRock))
	(logical (TravelFar Yes))
	(logical (Midi-ChlorianCount OffCharts))
	(logical (DontGetCocky))
	(logical (SearchOrHide Search))
	(logical (SearchOrScavenge Search))
	(logical (ForAdventure Yes))
	(logical (BlueMilk Cold))

   =>

   (assert (UI-state (display TauntaunQuestion)
                     (relation-asserted Tauntaun))))
)

(defrule CrystalsQuery

	(logical (ChoosePath GetOffRock))
	(logical (TravelFar Yes))
	(logical (Midi-ChlorianCount OffCharts))
	(logical (DontGetCocky))
	(logical (SearchOrHide Search))
	(logical (SearchOrScavenge Search))
	(logical (ForAdventure AdventureNo))

   =>

   (assert (UI-state (display CrystalsQuestion)
                     (relation-asserted Crystals)
					 (response HellYes)
                     (valid-answers HellYes)))
)

(defrule WhatBreakFromQuery

	(logical (ChoosePath Overworked))

   =>

   (assert (UI-state (display WhatBreakFromQuestion)
                     (relation-asserted WhatBreakFrom)
                     (response City)
                     (valid-answers City Work SameFaces)))
)

(defrule SelfDestructiveQuery

	(logical (ChoosePath Overworked))
	(logical (WhatBreakFrom SameFaces))

   =>

   (assert (UI-state (display SelfDestructiveQuestion)
                     (relation-asserted SelfDestructive)
                     (response Yes)
                     (valid-answers Yes No)))
)

(defrule SocialQuery

	(logical (ChoosePath Overworked))
	(logical (WhatBreakFrom SameFaces))
	(logical (SelfDestructive No))

   =>

   (assert (UI-state (display SocialQuestion)
                     (relation-asserted Social)
                     (response Yes)
                     (valid-answers Yes No AnimalsOverPeople)))
)

(defrule ByChoiceQuery

	(logical (ChoosePath Overworked))
	(logical (WhatBreakFrom SameFaces))
	(logical (SelfDestructive No))
	(logical (Social No))

   =>

   (assert (UI-state (display ByChoiceQuestion)
                     (relation-asserted ByChoice)
                     (response ChoiceYes)
                     (valid-answers ChoiceYes ChoiceNo)))
)

(defrule LightSaberQuery

	(logical (ChoosePath Overworked))
	(logical (WhatBreakFrom SameFaces))
	(logical (SelfDestructive No))
	(logical (Social No))
	(logical (ByChoice ChoiceYes))

   =>

   (assert (UI-state (display LightSaberQuestion)
                     (relation-asserted LightSaber)
                     (response RedSaber)
                     (valid-answers RedSaber BlueSaber)))
)

(defrule StopPoutingQuery

	(logical (ChoosePath Overworked))
	(logical (WhatBreakFrom SameFaces))
	(logical (SelfDestructive No))
	(logical (Social No))
	(logical (ByChoice ChoiceNo))

   =>

   (assert (UI-state (display StopPoutingQuestion)
                     (relation-asserted StopPouting)))
)

(defrule DescribeFriendsQuery

	(or
        (and
            (logical (ChoosePath Overworked))
            (logical (WhatBreakFrom SameFaces))
            (logical (SelfDestructive No))
            (logical (Social Yes))
        )
        (and
            (logical (ChoosePath Overworked))
            (logical (WhatBreakFrom SameFaces))
            (logical (SelfDestructive No))
            (logical (Social No))
            (logical (ByChoice ChoiceNo))
            (logical (StopPouting))
        )
	)

   =>

   (assert (UI-state (display DescribeFriendsQuestion)
                     (relation-asserted DescribeFriends)
                     (response Tight-Knit)
                     (valid-answers Tight-Knit)))
)

(defrule TimeTogetherQuery

	(logical (ChoosePath Overworked))
	(logical (WhatBreakFrom SameFaces))
	(logical (SelfDestructive No))
	(logical (Social Yes))
	(logical (DescribeFriends Tight-Knit))

   =>

   (assert (UI-state (display TimeTogetherQuestion)
                     (relation-asserted TimeTogether)
                     (response EatSushiEatSushi)
                     (valid-answers EatSushi LongTalks VideoGames)))
)

(defrule WhatAnimalQuery

	(logical (ChoosePath Overworked))
	(logical (WhatBreakFrom SameFaces))
	(logical (SelfDestructive No))
	(logical (Social AnimalsOverPeople))

   =>

   (assert (UI-state (display WhatAnimalQuestion)
                     (relation-asserted WhatAnimal)
                     (response Squid)
                     (valid-answers Squid Bear)))
)

(defrule MentallyPhysicallyQuery

	(logical (ChoosePath Overworked))
	(logical (WhatBreakFrom SameFaces))
	(logical (SelfDestructive Yes))

   =>

   (assert (UI-state (display MentallyPhysicallyQuestion)
                     (relation-asserted MentallyPhysically)
                     (response Mentally)
                     (valid-answers Mentally)))
)

(defrule BewareAngerQuery

	(logical (ChoosePath Overworked))
	(logical (WhatBreakFrom SameFaces))
	(logical (SelfDestructive Yes))
	(logical (MentallyPhysically Mentally))

   =>

   (assert (UI-state (display BewareAngerQuestion)
                     (relation-asserted BewareAnger)
                     (response DarkSide)
                     (valid-answers DarkSide)))
)

(defrule WhatWorkQuery

	(logical (ChoosePath Overworked))
	(logical (WhatBreakFrom Work))

   =>

   (assert (UI-state (display WhatWorkQuestion)
                     (relation-asserted WhatWork)
                     (response Business)
                     (valid-answers Business Retail Creative)))
)

(defrule WhatInspiredByQuery

	(logical (ChoosePath Overworked))
	(logical (WhatBreakFrom Work))
	(logical (WhatWork Creative))

   =>

   (assert (UI-state (display WhatInspiredByQuestion)
                     (relation-asserted WhatInspiredBy)
                     (response Artists)
                     (valid-answers Artists Posters)))
)

(defrule WhatMottoQuery

	(logical (ChoosePath Overworked))
	(logical (WhatBreakFrom Work))
	(logical (WhatWork Creative))
	(logical (WhatInspiredBy Posters))

   =>

   (assert (UI-state (display WhatMottoQuestion)
                     (relation-asserted WhatMotto)
                     (response BiggerFish)
                     (valid-answers BiggerFish HokeyReligion LiveProsper)))
)

(defrule WhatToBlastQuery

	(logical (ChoosePath Overworked))
	(logical (WhatBreakFrom Work))
	(logical (WhatWork Creative))
	(logical (WhatInspiredBy Posters))
	(logical (WhatMotto HokeyReligion))

   =>

   (assert (UI-state (display WhatToBlastQuestion)
                     (relation-asserted WhatToBlast)
                     (response Dug)
                     (valid-answers Dug Wampa WompRats)))
)

(defrule WhatPaintingsFramedQuery

	(logical (ChoosePath Overworked))
	(logical (WhatBreakFrom Work))
	(logical (WhatWork Creative))
	(logical (WhatInspiredBy Artists))

   =>

   (assert (UI-state (display WhatPaintingsFramedQuestion)
                     (relation-asserted WhatPaintingsFramed)
                     (response Escher)
                     (valid-answers Escher Hokusai)))
)

(defrule WhoNotWorkWithQuery

	(logical (ChoosePath Overworked))
	(logical (WhatBreakFrom Work))
	(logical (WhatWork Business))

   =>

   (assert (UI-state (display WhoNotWorkWithQuestion)
                     (relation-asserted WhoNotWorkWith)
                     (response Alderaan)
                     (valid-answers Alderaan TalkingSquid Toydarians)))
)

(defrule TooSoonQuery

	(logical (ChoosePath Overworked))
	(logical (WhatBreakFrom Work))
	(logical (WhatWork Business))
	(logical (WhoNotWorkWith Alderaan))

   =>

   (assert (UI-state (display TooSoonQuestion)
                     (relation-asserted TooSoon)))
)

(defrule WhatTravelWithoutQuery

	(logical (ChoosePath Overworked))
	(logical (WhatBreakFrom Work))
	(logical (WhatWork Retail))

   =>

   (assert (UI-state (display WhatTravelWithoutQuestion)
                     (relation-asserted WhatTravelWithout)
                     (response Book)
                     (valid-answers Book Camera GoPro Holophone)))
)

(defrule WhatGenreQuery

	(logical (ChoosePath Overworked))
	(logical (WhatBreakFrom Work))
	(logical (WhatWork Retail))
	(logical (WhatTravelWithout Book))

   =>

	(assert (UI-state (display WhatGenreQuestion)
						(relation-asserted WhatGenre)
						(response NonFiction)
						(valid-answers NonFiction SciFi)))
)

(defrule CommuneWithNatureQuery

	(logical (ChoosePath Overworked))
	(logical (WhatBreakFrom City))

   =>

	(assert (UI-state (display CommuneWithNatureQuestion)
						(relation-asserted CommuneWithNature)
						(response Yes)
						(valid-answers Yes Grumpy)))
)

;;;***********
;;;* ANSWERS *
;;;***********

(defrule Endor

    (or
        (and
            (logical (CommuneWithNature Yes))
            (logical (ChoosePath Overworked))
            (logical (WhatBreakFrom City))
        )
		(and
			(logical (ChoosePath Overworked))
			(logical (WhatBreakFrom SameFaces))
			(logical (SelfDestructive No))
			(logical (Social AnimalsOverPeople))
			(logical (WhatAnimal Bear))
		)
    )

   =>

   (assert (UI-state (display EndorAnswer)
                     (state final)))
)


(defrule Naboo

    (or
        (and
            (logical (ChoosePath Overworked))
            (logical (WhatBreakFrom Work))
            (logical (WhatWork Retail))
            (logical (WhatTravelWithout Book))
            (logical (WhatGenre NonFiction))
        )
        (and
            (logical (ChoosePath Overworked))
            (logical (WhatBreakFrom Work))
            (logical (WhatWork Business))
            (logical (WhoNotWorkWith Alderaan))
            (logical (TooSoon))
        )
		(and
			(logical (ChoosePath Overworked))
			(logical (WhatBreakFrom SameFaces))
			(logical (SelfDestructive No))
			(logical (Social Yes))
			(logical (DescribeFriends Tight-Knit))
			(logical (TimeTogether LongTalks))
		)
    )

   =>

   (assert (UI-state (display NabooAnswer)
                     (state final)))
)


(defrule MonCala

   (or
       (and
           (logical (CommuneWithNature Grumpy))
           (logical (ChoosePath Overworked))
           (logical (WhatBreakFrom City))
       )
       (and
           (logical (ChoosePath Overworked))
           (logical (WhatBreakFrom Work))
           (logical (WhatWork Creative))
           (logical (WhatInspiredBy Artists))
           (logical (WhatPaintingsFramed Hokusai))
       )
       (and
           (logical (ChoosePath Overworked))
           (logical (WhatBreakFrom Work))
           (logical (WhatWork Creative))
           (logical (WhatInspiredBy Posters))
           (logical (WhatMotto BiggerFish))
       )
		(and
			(logical (ChoosePath Overworked))
			(logical (WhatBreakFrom SameFaces))
			(logical (SelfDestructive No))
			(logical (Social AnimalsOverPeople))
			(logical (WhatAnimal Squid))
		)
		(and
			(logical (ChoosePath Overworked))
			(logical (WhatBreakFrom SameFaces))
			(logical (SelfDestructive No))
			(logical (Social Yes))
			(logical (DescribeFriends Tight-Knit))
			(logical (TimeTogether EatSushi))
		)
		(and
			(logical (ChoosePath GetOffRock))
			(logical (TravelFar Yes))
			(logical (Midi-ChlorianCount OffCharts))
			(logical (DontGetCocky))
			(logical (SearchOrHide Search))
			(logical (SearchOrScavenge Search))
			(logical (ForAdventure Yes))
			(logical (BlueMilk Warm))
			(logical (Trap))
		)
   )

   =>

   (assert (UI-state (display MonCalaAnswer)
                     (state final)))
)


(defrule Ryloth

   (or
        (and
            (logical (ChoosePath Overworked))
            (logical (WhatBreakFrom Work))
            (logical (WhatWork Retail))
            (logical (WhatTravelWithout Book))
            (logical (WhatGenre SciFi))
        )
        (and
            (logical (ChoosePath Overworked))
            (logical (WhatBreakFrom Work))
            (logical (WhatWork Retail))
            (logical (WhatTravelWithout Camera))
        )
        (and
            (logical (ChoosePath Overworked))
            (logical (WhatBreakFrom Work))
            (logical (WhatWork Creative))
            (logical (WhatInspiredBy Artists))
            (logical (WhatPaintingsFramed Escher))
        )
		(and
			(logical (ChoosePath Overworked))
			(logical (WhatBreakFrom SameFaces))
			(logical (SelfDestructive No))
			(logical (Social Yes))
			(logical (DescribeFriends Tight-Knit))
			(logical (TimeTogether VideoGames))
		)
   )

   =>

   (assert (UI-state (display RylothAnswer)
                     (state final)))
)


(defrule Mustafar

   (or
        (and
            (logical (ChoosePath Overworked))
            (logical (WhatBreakFrom Work))
            (logical (WhatWork Retail))
            (logical (WhatTravelWithout GoPro))
        )
        (and
            (logical (ChoosePath Overworked))
            (logical (WhatBreakFrom Work))
            (logical (WhatWork Business))
            (logical (WhoNotWorkWith TalkingSquid))
        )
   )

   =>

   (assert (UI-state (display MustafarAnswer)
                     (state final)))
)


(defrule Coruscant

   (or
        (and
            (logical (ChoosePath Overworked))
            (logical (WhatBreakFrom Work))
            (logical (WhatWork Retail))
            (logical (WhatTravelWithout Holophone))
        )
        (and
            (logical (ChoosePath Overworked))
            (logical (WhatBreakFrom Work))
            (logical (WhatWork Business))
            (logical (WhoNotWorkWith Toydarians))
        )
   )

   =>

   (assert (UI-state (display CoruscantAnswer)
                     (state final)))
)


(defrule Malastare

   (or
        (and
            (logical (ChoosePath Overworked))
            (logical (WhatBreakFrom Work))
            (logical (WhatWork Creative))
            (logical (WhatInspiredBy Posters))
            (logical (WhatMotto HokeyReligion))
            (logical (WhatToBlast Dug))
        )
   )

   =>

   (assert (UI-state (display MalastareAnswer)
                     (state final)))
)


(defrule Ilum

   (or
        (and
            (logical (ChoosePath Overworked))
            (logical (WhatBreakFrom Work))
            (logical (WhatWork Creative))
            (logical (WhatInspiredBy Posters))
            (logical (WhatMotto HokeyReligion))
            (logical (WhatToBlast Wampa))
        )
		(and
			(logical (ChoosePath Overworked))
			(logical (WhatBreakFrom SameFaces))
			(logical (SelfDestructive No))
			(logical (Social No))
			(logical (ByChoice ChoiceYes))
			(logical (LightSaber BlueSaber))
		)
		(and
			(logical (ChoosePath GetOffRock))
			(logical (TravelFar Yes))
			(logical (Midi-ChlorianCount OffCharts))
			(logical (DontGetCocky))
			(logical (SearchOrHide Search))
			(logical (SearchOrScavenge Search))
			(logical (ForAdventure AdventureNo))
			(logical (Crystals HellYes))
		)
		(and
			(logical (ChoosePath GetOffRock))
			(logical (TravelFar Yes))
			(logical (Midi-ChlorianCount OffCharts))
			(logical (DontGetCocky))
			(logical (SearchOrHide Search))
			(logical (SearchOrScavenge Search))
			(logical (ForAdventure Yes))
			(logical (BlueMilk Cold))
			(logical (Tauntaun))
		)
   )

   =>

   (assert (UI-state (display IlumAnswer)
                     (state final)))
)


(defrule Jakku

   (or
        (and
            (logical (ChoosePath Overworked))
            (logical (WhatBreakFrom Work))
            (logical (WhatWork Creative))
            (logical (WhatInspiredBy Posters))
            (logical (WhatMotto HokeyReligion))
            (logical (WhatToBlast WompRats))
        )
		(and
			(logical (ChoosePath Overworked))
			(logical (WhatBreakFrom SameFaces))
			(logical (SelfDestructive No))
			(logical (Social No))
			(logical (ByChoice ChoiceYes))
			(logical (LightSaber RedSaber))
		)
		(and
			(logical (ChoosePath GetOffRock))
			(logical (TravelFar Yes))
			(logical (Midi-ChlorianCount OffCharts))
			(logical (DontGetCocky))
			(logical (SearchOrHide Search))
			(logical (SearchOrScavenge Scavenge))
		)

   )

   =>

   (assert (UI-state (display JakkuAnswer)
                     (state final)))
)


(defrule NoVacation

   (or
        (and
            (logical (ChoosePath Overworked))
            (logical (WhatBreakFrom Work))
            (logical (WhatWork Creative))
            (logical (WhatInspiredBy Posters))
            (logical (WhatMotto LiveProsper))
        )
		(and
			(logical (ChoosePath GetOffRock))
			(logical (TravelFar Yes))
			(logical (Midi-ChlorianCount WhatMidi-chlorian))
		)
   )

   =>

   (assert (UI-state (display NoVacationAnswer)
                     (state final)))
)


(defrule SetFree

   (or
        (and
            (logical (ChoosePath Overworked))
			(logical (WhatBreakFrom SameFaces))
			(logical (SelfDestructive Yes))
			(logical (MentallyPhysically Mentally))
			(logical (BewareAnger DarkSide))
			
        )
   )

   =>

   (assert (UI-state (display SetFreeAnswer)
                     (state final)))
)



                     

;;;*************************
;;;* GUI INTERACTION RULES *
;;;*************************

(defrule ask-question

   (declare (salience 5))
   
   (UI-state (id ?id))
   
   ?f <- (state-list (sequence $?s&:(not (member$ ?id ?s))))
             
   =>
   
   (modify ?f (current ?id)
              (sequence ?id ?s))
   
   (halt))

(defrule handle-next-no-change-none-middle-of-chain

   (declare (salience 10))
   
   ?f1 <- (next ?id)

   ?f2 <- (state-list (current ?id) (sequence $? ?nid ?id $?))
                      
   =>
      
   (retract ?f1)
   
   (modify ?f2 (current ?nid))
   
   (halt))

(defrule handle-next-response-none-end-of-chain

   (declare (salience 10))
   
   ?f <- (next ?id)

   (state-list (sequence ?id $?))
   
   (UI-state (id ?id)
             (relation-asserted ?relation))
                   
   =>
      
   (retract ?f)

   (assert (add-response ?id)))   

(defrule handle-next-no-change-middle-of-chain

   (declare (salience 10))
   
   ?f1 <- (next ?id ?response)

   ?f2 <- (state-list (current ?id) (sequence $? ?nid ?id $?))
     
   (UI-state (id ?id) (response ?response))
   
   =>
      
   (retract ?f1)
   
   (modify ?f2 (current ?nid))
   
   (halt))

(defrule handle-next-change-middle-of-chain

   (declare (salience 10))
   
   (next ?id ?response)

   ?f1 <- (state-list (current ?id) (sequence ?nid $?b ?id $?e))
     
   (UI-state (id ?id) (response ~?response))
   
   ?f2 <- (UI-state (id ?nid))
   
   =>
         
   (modify ?f1 (sequence ?b ?id ?e))
   
   (retract ?f2))
   
(defrule handle-next-response-end-of-chain

   (declare (salience 10))
   
   ?f1 <- (next ?id ?response)
   
   (state-list (sequence ?id $?))
   
   ?f2 <- (UI-state (id ?id)
                    (response ?expected)
                    (relation-asserted ?relation))
                
   =>
      
   (retract ?f1)

   (if (neq ?response ?expected)
      then
      (modify ?f2 (response ?response)))
      
   (assert (add-response ?id ?response)))   

(defrule handle-add-response

   (declare (salience 10))
   
   (logical (UI-state (id ?id)
                      (relation-asserted ?relation)))
   
   ?f1 <- (add-response ?id ?response)
                
   =>
      
   (str-assert (str-cat "(" ?relation " " ?response ")"))
   
   (retract ?f1))   

(defrule handle-add-response-none

   (declare (salience 10))
   
   (logical (UI-state (id ?id)
                      (relation-asserted ?relation)))
   
   ?f1 <- (add-response ?id)
                
   =>
      
   (str-assert (str-cat "(" ?relation ")"))
   
   (retract ?f1))   

(defrule handle-prev

   (declare (salience 10))
      
   ?f1 <- (prev ?id)
   
   ?f2 <- (state-list (sequence $?b ?id ?p $?e))
                
   =>
   
   (retract ?f1)
   
   (modify ?f2 (current ?p))
   
   (halt))
   

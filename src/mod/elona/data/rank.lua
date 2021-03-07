data:add_type {
   name = "rank",
   fields = {}
}

data:add {
   _type = "elona.rank",
   _id = "arena",
   elona_id = 0,

   ordering = 100000 + 0 * 10000,

   -- >>>>>>>> shade2/init.hsp:1924 	rankNorma(rankArena) 	=20 ...
   decay_period_days = 20,
   -- <<<<<<<< shade2/init.hsp:1924 	rankNorma(rankArena) 	=20 ..

   calc_income = function(income)
      -- >>>>>>>> shade2/event.hsp:414 	if r=rankArena		:p=p*80/100 ...
      return income * 80 / 100
      -- <<<<<<<< shade2/event.hsp:414 	if r=rankArena		:p=p*80/100 ..
   end
}

data:add {
   _type = "elona.rank",
   _id = "pet_arena",
   elona_id = 1,

   ordering = 100000 + 1 * 10000,

   -- >>>>>>>> shade2/init.hsp:1925 	rankNorma(rankPetArena)	=60 ...
   decay_period_days = 60,
   -- <<<<<<<< shade2/init.hsp:1925 	rankNorma(rankPetArena)	=60 ..

   calc_income = function(income)
      -- >>>>>>>> shade2/event.hsp:415 	if r=rankPetArena	:p=p*70/100 ...
      return income * 70 / 100
      -- <<<<<<<< shade2/event.hsp:415 	if r=rankPetArena	:p=p*70/100 ..
   end
}

data:add {
   _type = "elona.rank",
   _id = "crawler",
   elona_id = 2,

   ordering = 100000 + 2 * 10000,

   -- >>>>>>>> shade2/init.hsp:1926 	rankNorma(rankCrawler)	=45 ...
   decay_period_days = 45,
   -- <<<<<<<< shade2/init.hsp:1926 	rankNorma(rankCrawler)	=45 ..

   calc_income = function(income)
      -- >>>>>>>> shade2/event.hsp:412 	if r=rankCrawler	:p=p*120/100 ...
      return income * 120 / 100
      -- <<<<<<<< shade2/event.hsp:412 	if r=rankCrawler	:p=p*120/100 ..
   end
}

data:add {
   _type = "elona.rank",
   _id = "museum",
   elona_id = 3,

   ordering = 100000 + 3 * 10000,
}

data:add {
   _type = "elona.rank",
   _id = "home",
   elona_id = 4,

   ordering = 100000 + 4 * 10000,

   calc_income = function(income)
      -- >>>>>>>> shade2/event.hsp:413 	if r=rankHome		:p=p*60/100 ...
      return income * 60 / 100
      -- <<<<<<<< shade2/event.hsp:413 	if r=rankHome		:p=p*60/100 ..
   end
}

data:add {
   _type = "elona.rank",
   _id = "shop",
   elona_id = 5,

   ordering = 100000 + 5 * 10000,

   calc_income = function(income)
      -- >>>>>>>> shade2/event.hsp:417 	if r=rankShop		:p=p*20/100 ...
      return income * 20 / 100
      -- <<<<<<<< shade2/event.hsp:417 	if r=rankShop		:p=p*20/100 ..
   end
}

data:add {
   _type = "elona.rank",
   _id = "vote",
   elona_id = 6,

   ordering = 100000 + 6 * 10000,

   -- >>>>>>>> shade2/init.hsp:1927 	rankNorma(rankVote)	=30 ...
   decay_period_days = 30,
   -- <<<<<<<< shade2/init.hsp:1927 	rankNorma(rankVote)	=30 ..

   calc_income = function(income)
      -- >>>>>>>> shade2/event.hsp:416 	if r=rankVote		:p=p*25/100 ...
      return income * 25 / 100
      -- <<<<<<<< shade2/event.hsp:416 	if r=rankVote		:p=p*25/100 ..
   end
}

data:add {
   _type = "elona.rank",
   _id = "fishing",
   elona_id = 7,

   ordering = 100000 + 7 * 10000
}

data:add {
   _type = "elona.rank",
   _id = "guild",
   elona_id = 8,

   ordering = 100000 + 8 * 10000
}

# delete anything that already exists
Response.delete_all
# reset the primary ids to start at 1
# when the next item is inserted/created
Response.reset_autoincrement

# create a bunch of data to test with
Response.create!([{ response_id: 1, stage_id: 1 , step response_content: "I\'m a bot that searches the best places nearby on Yelp, Facebook, Foursquare.\n For now, I can only search food or coffee places." } ])
Response.create!([{ response_id: 2, stage_id: 1 , response_content: "I\'m a bot that searches the best places nearby on Yelp, Facebook, Foursquare." } ])
Response.create!([{ response_id: 3, stage_id: 1 , response_content: "I\'m a bot that searches the best places nearby on Yelp and Facebook." } ])
Response.create!([{ response_id: 4, stage_id: 1 , response_content: "I\'m a bot that finds the best places nearby on Yelp and Facebook." } ])
Response.create!([{ response_id: 5, stage_id: 2 , response_content: "I\'m designed by Meric Dagli, '" } ])
Response.create!([{ response_id: 6, stage_id: 2 , response_content: "I\'m a bot that searches the best places nearby on Yelp, Facebook, Foursquare.\n For now, I can only search food or coffee places." } ])
Response.create!([{ response_id: 7, stage_id: 2 , response_content: "I\'m a bot that searches the best places nearby on Yelp, Facebook, Foursquare.\n For now, I can only search food or coffee places." } ])
Response.create!([{ response_id: 8, stage_id: 2 , response_content: "I\'m a bot that searches the best places nearby on Yelp, Facebook, Foursquare.\n For now, I can only search food or coffee places." } ])
Response.create!([{ response_id: 9, stage_id: 3 , response_content: "I\'m designed by Meric Dagli, who is a graduate interaction design student at Carnegie Mellon University." } ])
Response.create!([{ response_id: 10, stage_id: 3 , response_content: "I\'m designed by Meric Dagli, a graduate interaction design student at Carnegie Mellon University, who is originally from Turkey." } ])
Response.create!([{ response_id: 11, stage_id: 3 , response_content: "I\'m designed by Meric Dagli, A Turkish graduate interaction design student at Carnegie Mellon University." } ])
Response.create!([{ response_id: 12, stage_id: 3 , response_content: "I\'m designed by Meric Dagli, an interaction design student from Carnegie Mellon University." } ])
Response.create!([{ response_id: 13, stage_id: 4 , response_content: "I\'m a bot that searches the best places nearby on Yelp, Facebook, Foursquare.\n For now, I can only search food or coffee places." } ])
Response.create!([{ response_id: 14, stage_id: 4 , response_content: "I\'m a bot that searches the best places nearby on Yelp, Facebook, Foursquare.\n For now, I can only search food or coffee places." } ])
Response.create!([{ response_id: 15, stage_id: 4 , response_content: "I\'m a bot that searches the best places nearby on Yelp, Facebook, Foursquare.\n For now, I can only search food or coffee places." } ])
Response.create!([{ response_id: 16, stage_id: 4 , response_content: "I\'m a bot that searches the best places nearby on Yelp, Facebook, Foursquare.\n For now, I can only search food or coffee places." } ])
Response.create!([{ response_id: 17, stage_id: 5 , response_content: "I\'m a bot that searches the best places nearby on Yelp, Facebook, Foursquare.\n For now, I can only search food or coffee places." } ])
Response.create!([{ response_id: 18, stage_id: 5 , response_content: "I\'m a bot that searches the best places nearby on Yelp, Facebook, Foursquare.\n For now, I can only search food or coffee places." } ])
Response.create!([{ response_id: 18, stage_id: 5 , response_content: "I\'m a bot that searches the best places nearby on Yelp, Facebook, Foursquare.\n For now, I can only search food or coffee places." } ])
Response.create!([{ response_id: 18, stage_id: 5 , response_content: "I\'m a bot that searches the best places nearby on Yelp, Facebook, Foursquare.\n For now, I can only search food or coffee places." } ])

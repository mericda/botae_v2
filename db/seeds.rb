# delete anything that already exists
Response.delete_all
# reset the primary ids to start at 1
# when the next item is inserted/created
#Response.reset_autoincrement

# create a bunch of data to test with
Response.create!([{ response_id: 1, stage_id: 1 , step_id: 1 ,response_content: "I\'m a bot that searches the best places nearby on Yelp, Facebook, Foursquare. For now, I can only search food or coffee places." } ])
Response.create!([{ response_id: 2, stage_id: 1 , step_id: 1 ,response_content: "I\'m a bot that searches the best places nearby on Yelp, Facebook, Foursquare." } ])
Response.create!([{ response_id: 3, stage_id: 1 , step_id: 2 ,response_content: "I try to understand the context, in this case where you are, and navigate you in the overcrowded food and coffee scene." } ])
Response.create!([{ response_id: 4, stage_id: 1 , step_id: 2 ,response_content: "I use data to better understand the context,and suggest personalized places to check out." } ])
Response.create!([{ response_id: 5, stage_id: 2 , step_id: 1 ,response_content: "Why Botae? Botae is its designer\'s early exploration of how Messenger bots can interact with users." } ])
Response.create!([{ response_id: 6, stage_id: 2 , step_id: 1 ,response_content: "The idea of Botae came from its designer\'s own need of finding that best place to eat nearby." } ])
Response.create!([{ response_id: 7, stage_id: 2 , step_id: 2 ,response_content: "Botae answers the question of \'Where should I eat now?\'",  } ])
Response.create!([{ response_id: 8, stage_id: 2 , step_id: 2 ,response_content: "Botae is a bot, because you don\'t need another app in your phone, right?" } ])
Response.create!([{ response_id: 9, stage_id: 3 , step_id: 1 ,response_content: "I\'m designed by Meric Dagli, who is a graduate interaction design student at Carnegie Mellon University." } ])
Response.create!([{ response_id: 10, stage_id: 3 , step_id: 1 ,response_content: "I\'m designed by Meric Dagli, a graduate interaction design student at Carnegie Mellon University, who is originally from Turkey." } ])
Response.create!([{ response_id: 11, stage_id: 3 , step_id: 1 ,response_content: "My father is Meriç Dağlı, who is a graduate interaction design student at Carnegie Mellon University." } ])
Response.create!([{ response_id: 12, stage_id: 3 , step_id: 1 ,response_content: "My father is Meric Dagli, a graduate interaction design student at Carnegie Mellon University, who is originally from Turkey." } ])
Response.create!([{ response_id: 13, stage_id: 4 , step_id: 1 ,response_content: "In addition, I may also find places among your Facebook Friends by running a similarity-based classification algorithm." } ])
Response.create!([{ response_id: 14, stage_id: 4 , step_id: 1 ,response_content: "In addition, I may also find places among your Facebook Friends by running a smart algorithm." } ])
Response.create!([{ response_id: 15, stage_id: 4 , step_id: 2 ,response_content: "I said \'I may find it\' is because I cannot always read data of your friends, or simply there is not enough data." } ])
Response.create!([{ response_id: 16, stage_id: 4 , step_id: 2 ,response_content: "I said \'I may find it\' is because I cannot always read data of your friends." } ])
Response.create!([{ response_id: 17, stage_id: 5 , step_id: 1 ,response_content: "Want to see some suggestions before you try? Here is a screenshot of one of my earlier suggestions." } ])
Response.create!([{ response_id: 18, stage_id: 5 , step_id: 1 ,response_content: "Not sure about trying? Here is an example suggestion." } ])
Response.create!([{ response_id: 18, stage_id: 5 , step_id: 2 ,response_content: "http://mericdagli.com/botae/p1.jpg" } ])
Response.create!([{ response_id: 18, stage_id: 5 , step_id: 2 ,response_content: "http://mericdagli.com/botae/p2.jpg" } ])

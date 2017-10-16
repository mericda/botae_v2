# delete anything that already exists
Response.delete_all
# reset the primary ids to start at 1
# when the next item is inserted/created
Response.reset_autoincrement

# create a bunch of data to test with
Response.create!([{ name: "Example Response", list_id: 1 } ])
Response.create!([{ name: "Example 2", list_id: 1 } ])
Response.create!([{ name: "Example 3", list_id: 2 } ])
Response.create!([{ name: "Example 4", list_id: 1 } ])

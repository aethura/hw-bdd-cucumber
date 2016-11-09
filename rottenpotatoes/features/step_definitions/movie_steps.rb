# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  pos_e1 = page.body.index(e1)
  pos_e2 = page.body.index(e2)
  if (pos_e1.nil? || pos_e2.nil?)
  	fail "Title does not exist"
  elsif (pos_e1.should_not >pos_e2)
  	fail "Out of Order"
  end
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
	prefix = uncheck || ""
	rating_list.split(', ').each do |rating|
		step %{I #{prefix}check "ratings_#{rating}"}
	end
end

Then /I should (not )?see all movies with the following ratings: (.*)/ do |not_see, rating_list|
  # Make sure that all movies with the following ratings in the app are (non) visible in the table
	prefix = not_see || ""
	list = rating_list.split(',')
	Movie.all.each do |movie|
		if (list.include?(movie.rating))
			step %{I should #{prefix}see "#{movie.title}"}
		end
	end
end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
	Movie.all.each do |movie|
		step %{I should see "#{movie.title}"}
	end
end
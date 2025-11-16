Zomato Data Exploration & Analysis Using SQL 

To uncover meaningful patterns in Zomato’s restaurant ecosystem, I conducted an in-depth SQL exploration of a dataset with over 9,000 restaurant records. The dataset included fields such as restaurant identifiers, names, city details, locations, cuisines, and other attributes.

🔍 Data Exploration Tasks Performed

1.Reviewed the database schema to understand column structures, data types, and constraints.
2.Checked for duplicate values in the RestaurantId field.
3.Removed irrelevant or redundant columns to streamline analysis.
4.Joined two tables using the CountryCode key and added a Country_Name column.
5.Identified and standardized incorrectly spelled city names.
6.Used window functions to generate rolling/moving counts of restaurants.
7.Computed the minimum, maximum, and average for votes, ratings, and currency values.
8.Created a custom rating category column to group restaurants effectively.

📊 Insights Derived After Analysis

1. 90.67% of the restaurants in the dataset are located in India, followed by the USA (4.45%).
2.Out of 15 countries, only two support online delivery:
India: 28.01% of restaurants
UAE: 46.67% of restaurants
3.Since most entries were from India, further analysis was focused there.
4.Top Indian Locations with Highest Restaurant Counts:
Connaught Place, New Delhi → 122 restaurants
Rajouri Garden → 99 restaurants
Shahdara → 87 restaurants
5.North Indian cuisine is the most prominent in Connaught Place.
6.Out of the 122 restaurants in Connaught Place, only 54 offer table booking.
7.Restaurants with table reservation facilities have an average rating of 3.9, slightly higher than 3.7 for those without.
8.The best moderately priced Indian restaurant (cost for two < ₹1000, rating > 4, votes > 4, and offering both booking + delivery):
India Restaurant, Kolkata  , Restaurant ID: 20747

### Hollywood blockbuster Case ##

This problem was given to me as part of selection process for a Data Scientist role. Unfortunately I could not crack it during the process, but since then this problem became an infatuation for me. I tried several iterations (almost everyday) to improve it more and more. Till now I have reached to a satisfactory level but there is still room for improvement.

Outline:

The Hollywood movie production business has a very instinct and contact driven low-tech decision making process that generates a portfolio of movies that a production house decides to fund in any given year. The same type of decision making process is employed by movie stars and their agents to decide which projects to pursue and which ones to pass. This leads to high degree of variation in the success rate of projects (as measured by gross box office receipts and return in investment). Most production houses employ a portfolio driven approach and diversify their risk across a number of low, medium and high budget movies.

There is a variety of academic research that suggests that attributes like genre, source, use of computer graphics, star power of the cast etc  have some degree of predictive power in classifying the degree of success of a project. Further, the emergence of social media has made it possible to track the collective sentiment around a movie project long before committing a sizable amount of capital on production, distribution and marketing.

The following research papers focused on Hollywood movies demonstrates that certain data attributes that have predictive power
and can help anticipate and improve the odds of success.

http://www.mmo.org.tr/resimler/dosya_ekler/c5b45ddb3ff1f62_ek.pdf

The challenge is to use the training data set to build a model to predict the target variable 'Category' in column O of the training file. The prediction accuracy will be tested by applying the model to the scoring data set. The actual values for the 'Category' target variable will be provided after submissions have been received. During the case interview, a higher emphasis will be placed on the thought process regarding the choice of the modeling approach rather than the raw 'out of sample' prediction accuracy.


Approach:

One peculiar thing that I noticed in the data set was that the training data set had a column called "total" that shows the box-office performance of each movie in monetary terms and it is highly correlated with "Category" column (in fact, "Category" values are decided bases on a movie's box office collection only). Interestingly, this column is not given in scoring data set. 

After identifying this interesting thing, my approach became clear. First build a model to predict "total" and then take the predictions as an input for the final model.

I have tried to utilize the power of both boosting and bagging to reach to final results. My solution is in form of an Ipthon-notebook in this repository (below is the link for it).

https://github.com/AD1985/Movie-Problem/blob/master/Quantiphi-Problem.ipynb

The accuracy level achieved in training set is ~83%. I believe this can be improved further using ensembling or neural networks. 


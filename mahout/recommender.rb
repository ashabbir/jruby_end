recommender = JrubyMahout::Recommender.new(
  "PearsonCorrelationSimilarity", 5,
  "GenericUserBasedRecommender",false
)

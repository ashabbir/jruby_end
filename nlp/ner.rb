require 'java'

require "jars/opennlp-tools-1.5.3.jar"
require "jars/opennlp-maxent-3.0.3.jar"
require 'pry'


java_import java.io.FileInputStream;
java_import java.io.IOException;
java_import java.io.InputStream;


def sent_detect(text)
  is = FileInputStream.new("models/en-sent.bin")
  model = Java::OpennlpToolsSentdetect::SentenceModel.new(is)
  sdetector = Java::OpennlpToolsSentdetect::SentenceDetectorME.new(model)

  sentences = sdetector.sentDetect(text)
  is.close
  return sentences
end

def tokenize(text)
  is = FileInputStream.new("models/en-token.bin")
  model = Java::OpennlpToolsTokenize::TokenizerModel.new(is) #opennlp.tools.tokenize.TokenizerModel;
  tokenizer = Java::OpennlpToolsTokenize::TokenizerME.new(model) #opennlp.tools.tokenize.TokenizerME;

  tokens = tokenizer.tokenize(text)
  is.close();
  return tokens
end

def ner(tokens, finders)
  results = []

  finders.each do |f|
    name_spans = f.find(tokens)
    name_spans.each do |s|
      start = s.start.to_i
      en = s.end.to_i
      t = tokens.to_a[start..en]
      t = [] if t.nil?
      t.reject!{|x| x.length == 1}
      type = s.get_type
      results << { type => t}
    end
  end
  return results

end

def nlp_pipeline(text)
  entities = []
  finders = load_models
  #sent
  sent = sent_detect(text)
  #token
  sent.each do |s|
    entities << ner(tokenize(s), finders)
  end

  return entities
end


def load_models
  mfiles = Dir.glob('models/*ner*')
  finders = []
  # mfiles loop through files
  mfiles.each do |f|
    is = FileInputStream.new(f)
    model = Java::OpennlpToolsNamefind::TokenNameFinderModel.new(is) #opennlp.tools.namefind.TokenNameFinderModel;
    nameFinder = Java::OpennlpToolsNamefind::NameFinderME.new(model) #opennlp.tools.namefind.NameFinderME;
    is.close()
    finders << nameFinder
  end
  return finders
end

data = []
data << "Barack Obama is the president of United States"
data << "CS at HSBC sucks"
data << "Hi my name is Ahmed Shabbir. I am 33 years old. I live in New York. I have 300 dollars. Iphone is a good product."
data << "Hi. How are you? This is Mike. I am Ahmed's friend. I live in UK. I came to USA in 2014. I work for News group international."

=begin
processed = []
data.each do |text|
  sentences = sent_detect(text)
  entities = {}
  sentences.each do |s|
    tokens = tokenize(s)
    ent= ner(tokens, finders)
    ent.each do |e|
      e.each do |k,v|
        if entities[k].nil?
          entities[k] = v.join(" ")
        else
          entities[k] = entities[k] <<  v.join(" ")
        end
      end
    end
  end
  processed << {para: text, entities: entities}
end
=end

data.each do |d|
  puts nlp_pipeline(d)
end

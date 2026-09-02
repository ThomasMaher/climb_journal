json.array! @boulders.each do |boulder|
  json.partial! partial: "boulder", locals: { boulder: boulder }
end

@boulders.each do |boulder|
  render "boulder", locals: { boulder: boulder }
end

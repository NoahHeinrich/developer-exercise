module Where
  def where(hash = {})
    array_to_return = []
    self.each do |item|
      if compare_hash(hash, item)
        array_to_return << item
      end
    end
    array_to_return
  end

  private
  def compare_hash(first_hash, second_hash)
    first_hash.each do |key, value|
        if value.is_a? Numeric
            if second_hash[key] != value
                return false
            end
        else
            test_array =  second_hash[key].scan(value)
            if test_array.empty?
                return false
            end
        end
    end
    true
  end
end
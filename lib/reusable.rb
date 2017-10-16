module Reusable

  # This function takes an attribute from 1 to 100 and maps it to a range from low to high
  # If inverse is true, then it maps the attribute according to an inverse relationship
  def map_attribute_to_range(attribute, low, high, inverse)
    attribute_percent = attribute.to_f/100.0 # 0 to 1
    range = high - low
    if inverse
      val = high - range * attribute_percent
    else
      val = low + range * attribute_percent
    end
    val
  end

  def color_good
    "#267373"
  end

  def color_bad
    "#854747"
  end

  # Generates a number based on a pseudo-random gaussian distribution
  def randomGaussian
    ((rand() +
    rand() + rand() +
    rand() + rand() +
    rand()) - 3) / 3;
  end

  # This function generates a distribution of 100 data points between a min and max value, with desired mean and standard deviation.
  def generateDistribution(min, max, mean, stdev)
    counter = 0
    idealMean = mean
    idealStdev = stdev
    numDataPts = 100
    bias = 0
    skew = 1
    randomData = calculateData(bias, skew, min, max, mean, stdev, numDataPts)
    newMean = calculateMean(randomData)
    newStdev = calculateStDev(randomData)
    meanError = idealMean/newMean
    stdevError = idealStdev/newStdev
    while meanError > 1.01 || meanError < 0.99 || stdevError > 1.01 || stdevError < 0.99 do
      if meanError > 1.01
        bias += 0.1
      elsif meanError < 0.99
        bias -= 0.1
      end
      if stdevError > 1.1
        skew *= 0.9
      elsif stdevError < 0.9
        skew *= 1.1
      end
      randomData = calculateData(bias, skew, min, max, mean, stdev, numDataPts)
      newMean = calculateMean(randomData)
      newStdev = calculateStDev(randomData)
      meanError = idealMean/newMean
      stdevError = idealStdev/newStdev
      counter = counter + 1
      if counter > 99
        break
      end
    end
    randomData
  end

  # random values from a distribution with a given min, max, mean, stdev
  def getRandomValue(bias, skew, min, max, mean, stdev)
    range = max - min
    mid = min + range/2
    unitGaussian = randomGaussian
    biasFactor = Math.exp(bias)
    value = (mid + (range * (biasFactor / (biasFactor + Math.exp(-unitGaussian / skew)) - 0.5)))
  end

  # Helper function for generateDistribution
  def calculateData(bias, skew, min, max, mean, stdev, numDataPts)
    randomData = Array.new(numDataPts)
    for i in 0..numDataPts-1
      randomData[i] = getRandomValue(bias, skew, min, max, mean, stdev)
    end
    randomData
  end

  # Calculate mean of a set of data
  def calculateMean(randomData)
    numDataPts = randomData.length
    sum = 0
    for i in 0..numDataPts-1
      sum += randomData[i]
    end
    mean = sum/numDataPts
  end

  # Calculate the standard deviation from a set of data
  def calculateStDev(randomData)
    numDataPts = randomData.length
    mean = calculateMean(randomData)
    sum = 0
    for i in 0..numDataPts-1
      sum += (randomData[i] - mean) ** 2
    end
    stdev = Math.sqrt(sum/numDataPts)
  end
end

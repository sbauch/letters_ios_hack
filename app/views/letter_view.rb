class LetterView < UIView
  attr_accessor :letter, :delegate
  def initWithLetter(letter, index)
    self.letter = letter
    self.initWithFrame([[(index * 80) + (index *5),0],[80,80]]).tap do
      self.backgroundColor = UIColor.whiteColor
      self.alpha = 0.75
      self.layer.cornerRadius = 5
      self.layer.masksToBounds = true
      label = UILabel.alloc.initWithFrame([[10,10],[60,60]]).tap do |lbl|
        lbl.text = self.letter
        lbl.textColor = "#161446".uicolor
        lbl.font = UIFont.fontWithName('HelveticaNeue-UltraLight', size: 54)
        lbl.textAlignment = NSTextAlignmentCenter
      end
      self.addSubview(label)

      self.on_tap do
        delegate.letterChosen(self.letter)
      end
      pan = UISwipeGestureRecognizer.alloc.initWithTarget(self, action:"panUp:")
      self.addGestureRecognizer(pan)

    end


  end

  def panUp(recognizer)
    loc = recognizer.locationOfTouchinView(self.superview)
    p loc
    delegate.letterChosen(self.letter, loc)
  end

end
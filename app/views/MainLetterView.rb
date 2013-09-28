class MainLetterView < UIView
    attr_accessor :letter, :delegate, :new_letter
  def initWithLetter(letter, andIndex:index, dragPos:drag_pos)
    self.letter = letter
    self.userInteractionEnabled = true

    if drag_pos
      frame = drag_pos
    else
      frame = [[(index * 80) + ((index + 1) * 10), 60],[80,80]]
    end
    self.initWithFrame(frame).tap do
      self.backgroundColor = UIColor.whiteColor
      self.alpha = 0.8
      self.layer.cornerRadius = 5
      self.layer.masksToBounds = true
      label = UILabel.alloc.initWithFrame([[10, 10],[60, 60]]).tap do |lbl|
        lbl.text = self.letter
        lbl.textAlignment = NSTextAlignmentCenter
        lbl.textColor = "#161446".uicolor
        lbl.font = UIFont.fontWithName('HelveticaNeue-UltraLight', size: 54)
      end
      self.addSubview(label)
      makeDraggable
    end

  end

  def addClose
    label = UILabel.alloc.initWithFrame([[70,10],[10,10]]).tap do |lbl|
      lbl.text = "X"
      lbl.userInteractionEnabled = true
    end

    self.addSubview(label)

    label.on_tap do

    end

  end

  def makeDraggable
    pan = UIPanGestureRecognizer.alloc.initWithTarget(self, action: "panItem:")
    self.addGestureRecognizer(pan)
  end

  def panItem(recognizer)
    translation = recognizer.translationInView(self.superview)
    frame = self.frame
    frame.origin.x += translation.x
    frame.origin.y += translation.y


    self.frame = frame

    if recognizer.state == UIGestureRecognizerStateEnded
      if frame.origin.x > Device.screen.height - 100 && frame.origin.y > Device.screen.width - 100 && self.new_letter
        delegate.revealLetterSelect
        self.removeFromSuperview
      end
      delegate.organizeLetters
    end

    # reset the translation so we will not have accumulate data next time.
    recognizer.setTranslation(CGPointZero, inView: self.superview)
  end

end
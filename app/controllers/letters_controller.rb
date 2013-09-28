class LettersController < UIViewController

  def viewDidLoad
    super
    #unless UIApplication.sharedApplication.delegate.settings.game_id
      getPlayerInfo
    #end
    @allLetters = ('A'..'Z').to_a
    addBg
    setupScrollView
    addTrashcan
    addSubmitGesture
  end

  def getPlayerInfo
    @playerInfo = UIAlertView.alloc.initWithTitle("Join a Game", message:"Enter your name and game code to join a a game", delegate:self, cancelButtonTitle:nil, otherButtonTitles:"Submit", nil)
    @playerInfo.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput
    @playerInfo.show
  end

  def alertView(alert, clickedButtonAtIndex:index)
    MBProgressHUD.showHUDAddedTo(self.view, animated:true)
    if alert == @playerInfo
      name = alert.textFieldAtIndex(0).text
      game_code = alert.textFieldAtIndex(1).text

      LettersApi.addPlayer(name, game_code) do |response, error|
        MBProgressHUD.hideHUDForView(self.view, animated:true)
        if error
          App.alert('Something went wrong! Double check your code and try again')
          getPlayerInfo
        else
          id = response['_id']
          UIApplication.sharedApplication.delegate.settings.game_id = id
          word = response['current_word']
          @letters = word.upcase.split(//)
          addLetters(@letters)
          @isTurn = true #NB
        end
      end
    end

  end

  def addBg
    bg = UIImageView.alloc.initWithImage('bg'.uiimage)
    self.view.addSubview(bg)
  end

  def addLetters(letters)
    letters.each_with_index do |ltr, index|
      board_letter = MainLetterView.alloc.initWithLetter(ltr, andIndex:index, dragPos:false)
      board_letter.delegate = self
      self.view.addSubview(board_letter)
    end

  end

  def setupScrollView
    @scrollView = UIScrollView.alloc.initWithFrame([[8, 232],[Device.screen.height - 16, 80]])
    @scrollView.delegate = self
    @scrollView.backgroundColor = UIColor.clearColor
    self.view.addSubview(@scrollView)

    @scrollView.contentSize = [85 * 26, 40]
    @scrollView.userInteractionEnabled = true

    @allLetters.each_with_index do  |ltr, index|
      letterView = LetterView.alloc.initWithLetter(ltr, index)
      letterView.delegate = self
      @scrollView.addSubview(letterView)
    end

  end

  def addTrashcan
    @trash = UIImageView.alloc.initWithImage("trashcan".uiimage).tap do |img|
      img.frame = [[Device.screen.height - 80, Device.screen.width - 80],[80, 80]]
      img.alpha = 0.0
    end
    self.view.insertSubview(@trash, belowSubview:@scrollView)

  end

  def addSubmitGesture
    swipe = UISwipeGestureRecognizer.alloc.initWithTarget(self, action:"submitWord:")
    swipe.direction = UISwipeGestureRecognizerDirectionUp
    swipe.numberOfTouchesRequired = 2
    self.view.addGestureRecognizer(swipe)
  end

  def letterChosen(letter, location=nil)
    if location
      new_board_letter = MainLetterView.alloc.initWithLetter(letter, andIndex:@letters.count, dragPos:location)
    else
      new_board_letter = MainLetterView.alloc.initWithLetter(letter, andIndex:@letters.count, dragPos:false)
    end
    new_board_letter.new_letter = true
    new_board_letter.delegate = self
    new_board_letter.layer.borderColor = "#62a977".uicolor.cgcolor
    new_board_letter.layer.borderWidth = 3.0
    self.view.addSubview(new_board_letter)
    @scrollView.slide :down, 88 do |completed|
      @trash.fade_in(0.3)
      p 'done'
    end

  end

  def organizeLetters
    letterViews = self.view.subviews.select{|v| v.is_a?(MainLetterView)}
    sortedLetterViews = letterViews.sort!{ |a,b| a.origin.x <=> b.origin.x }
    sortedLetterViews.each_with_index do |v, index|
      v.move_to([(index * 80) + ((index + 1) * 10), 60])
    end

  end

  def revealLetterSelect
    @trash.fade_out(0.3)
    organizeLetters
    @scrollView.slide :up, 88
  end

  def submitWord(recognizer)
    return unless @isTurn
    word_ary = self.view.subviews.select{|v| v.is_a?(MainLetterView)} \
                                     .sort!{ |a,b| a.origin.x <=> b.origin.x } \
                                     .collect{|l| l.letter}

    if @letters != word_ary
      MBProgressHUD.showHUDAddedTo(self.view, animated:true)
      submitWordApi(word_ary.join)
    else
      p 'didnt change'
    end
  end

  def submitWordApi(word)
    LettersApi.submitWord(word) do |response, error|
      MBProgressHUD.hideHUDForView(self.view, animated:true)
      if error
        App.alert('Something went wrong! Submit your word again.')
      else
        App.alert('Nice Word!')
        @isTurn = false
        # do something like show points change or something
      end
    end
  end

  def setTurn(word)
    @letters = word.split(//)
    addLetters(@letters)
    @isTurn = true
  end

end
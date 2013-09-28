class HUD
  def self.wrap(view, operation, callback)
    MBProgressHUD.showHUDAddedTo(view, animated:true)
    BW::Reactor.defer(operation, proc do
      MBProgressHUD.hideHUDForView(view, animated:true)
      callback.call
    end)
  end
end
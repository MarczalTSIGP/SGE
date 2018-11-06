module DeviseRoutingHelpers
  def mock_warden_for_route_tests!
    warden = double
    allow_any_instance_of(ActionDispatch::Request).to(receive(:env).and_wrap_original do |orig|
      env = orig.call
      env['warden'] = warden
      env
    end)
    allow(warden).to receive(:authenticate!).and_return(true)
  end
end

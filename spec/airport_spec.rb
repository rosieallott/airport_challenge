require 'airport'

describe Airport do
  subject(:airport) { described_class.new }
  let(:plane) { double :plane }
  let(:weather) { double :weather}

  context "weather is fine for these examples" do
    before do
      allow(airport).to receive(:weather_check).and_return(nil)
      allow(plane).to receive(:plane_landed)
      allow(plane).to receive(:plane_taking_off)
    end
    #planes landing tests
    it {expect(airport).to respond_to(:land).with(1).argument}
    it 'confirms the plane is at that airport once landed' do
      airport.land(plane)
      expect(airport.instance_variable_get(:@planes)).to include plane
    end
    it 'will not allow planes to land if airport full' do
      Airport::CAPACITY.times { subject.land(Plane.new)}
      expect { airport.land(Plane.new) }.to raise_error 'Airport full'
    end
    it 'cannot land the same plane twice' do
      airport.land(plane)
      msg = "This plane has already landed"
      expect { airport.land(plane) }.to raise_error (msg)
    end

  #planes taking off tests
    it {expect(airport).to respond_to(:take_off).with(1).argument}
    it 'confirms the plane is not at that airport once taken off' do
      airport.land(plane)
      airport.take_off(plane)
      expect(airport.instance_variable_get(:@planes)).to_not include plane
    end
    it 'no planes can take off if airport empty' do
      msg = "no planes at the airport"
      expect { airport.take_off(plane) }.to raise_error (msg)
    end
    it 'plane cannot take off if not at the airport' do
      airport.land(plane)
      airport.land(Plane.new)
      airport.take_off(plane)
      msg = "This plane has already taken off from this airport"
      expect { airport.take_off(plane) }.to raise_error (msg)
    end
  end

  it 'will not let plane take off if stormy' do
    allow(plane).to receive(:plane_landed)
    allow(airport).to receive(:weather_check).and_return(nil)
    airport.land(plane)
    allow(airport).to receive(:weather_check).and_return("stormy")
    msg = "too stormy to take off"
    expect{airport.take_off(plane)}.to raise_error(msg)
  end

  context "weather is stormy for these examples" do
    before do
      allow(airport).to receive(:weather_check).and_return("stormy")
    end

    it 'will not let plane land if stormy' do
      msg = "too stormy to land"
      expect{airport.land(plane)}.to raise_error(msg)
    end
  end

  describe 'airport initialization' do
    it 'should have a default capacity' do
      expect(airport.instance_variable_get(:@capacity)).to eq Airport::CAPACITY
    end

    it 'can have a custom capacity' do
      airport = Airport.new(30)
      expect(airport.instance_variable_get(:@capacity)).to eq 30
    end
  end
end

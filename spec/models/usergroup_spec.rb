require 'spec_helper'

describe Usergroup do
  let(:every_second_wednesday) { Usergroup.new.tap { |it| it.recurring = 'second wednesday 18:30' } }

  context "parsing of recurring" do
    context "as string" do
      it "parses recurring and translates it" do
        every_second_wednesday.localized_recurring.should eql('jeden 2. Mittwoch im Monat')
      end
    end

    context "as date/time" do
      let(:rughh) { Whitelabel.label_for("hamburg") }
      let(:colognerb) { Whitelabel.label_for("cologne") }
      let(:hackhb) { Whitelabel.label_for("bremen") }
      let(:karlsruhe) { Whitelabel.label_for("karlsruhe")}
      let(:_1830) { Usergroup.new.tap { |it| it.recurring = 'second wednesday 18:30' } }

      let(:some_date) { Time.new(2011, 9, 1, 0, 0, 0) }
      let(:first_wednesday) { Time.new(2011, 9, 7, 0, 0, 0) }
      let(:second_wednesday) { Time.new(2011, 9, 14, 0, 0, 0) }
      let(:third_wednesday) { Time.new(2011, 9, 21, 0, 0, 0) }

      context "#next_event_date" do
        it "should always be in the future on wednesday" do
          [rughh, hackhb, colognerb, karlsruhe].each do |usergroup|
            usergroup.next_event_date.should be_wednesday
            usergroup.next_event_date.should be > Date.today
          end
        end

        it 'should include the parsed time, also' do
          _1830.next_event_date.hour.should eq(18)
          _1830.next_event_date.min.should eq(30)
        end
      end

      context '#parse_recurring_date' do
        it "should find the right wednesday" do
          hackhb.parse_recurring_date(some_date).should eql(first_wednesday)
          rughh.parse_recurring_date(some_date).should eql(second_wednesday)
          colognerb.parse_recurring_date(some_date).should eql(third_wednesday)
        end
      end

      context '#parse_recurring_time' do
        it "should return a time with 19:00 as default" do
          parsed_time = hackhb.parse_recurring_time
          parsed_time.hour.should eql(19)
          parsed_time.min.should eql(0)
        end

        it "should parse the recurring time" do
          rughh.recurring = 'second wednesday 18:30'
          parsed_time = rughh.parse_recurring_time
          parsed_time.hour.should eql(18)
          parsed_time.min.should eql(30)
        end
      end
    end
  end
end

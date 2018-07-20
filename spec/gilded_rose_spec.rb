require 'gilded_rose'

describe GildedRose do

  before(:each) do
    @bread = Item.new("Bread", 10, 40)
    @milk = Item.new("Mily", 0, 10)
    @agedbrie = Item.new("Aged Brie", 10, 10)
    @moreagedbrie = Item.new("Aged Brie", 5, 50)
    @sulfuras = Item.new("Sulfuras, Hand of Ragnaros", 10, 50)
    @backstagepasses = Item.new("Backstage passes to a TAFKAL80ETC concert", 12, 10)
    @conjured_item = Item.new("Conjured", 10, 30)
    @gildedrose = GildedRose.new([@bread, @milk, @agedbrie, @moreagedbrie, @sulfuras, @backstagepasses])
  end


  describe "#update_quality" do

    context "if the item is regular (ie. not legendary, conjured, Aged Brie or Backstage Passes)" do

      it 'decreases the quality of item' do
        expect{ @gildedrose.update_quality }.to change { @bread.quality }. by -1
      end

      it 'decreases the sell-in value of item' do
        expect{ @gildedrose.update_quality }.to change { @bread.sell_in }. by -1
      end

      it "will never allow the quality of an item to be negative" do
        11.times { @gildedrose.update_quality }
        expect{ @gildedrose.update_quality }.to change { @milk.quality }. by 0
      end

      context "if the sell by date has passed" do
        it "degrades the quality of an item twice as fast" do
          expect{ @gildedrose.update_quality }.to change { @milk.quality }. by -2
        end
      end
    end

    context "if the item name is Aged Brie" do
      it "increases the quality the older it gets" do
        expect{ @gildedrose.update_quality }.to change { @agedbrie.quality }. by 1
      end

      it "will never allow the quality of an item to be higher than 50" do
        expect{ @gildedrose.update_quality }.to change { @moreagedbrie.quality }. by 0
      end
    end

    context "if the item name is Sulfuras" do
      it "never decreases in quality or has to be sold" do
        expect{ @gildedrose.update_quality }.to change { @sulfuras.quality }. by 0
      end
    end

    context "if the item name is Backstage Passes" do
      it "increases the quality the older it gets when there are more than 10 days till SellIn" do
        expect{ @gildedrose.update_quality }.to change { @backstagepasses.quality }. by 1
      end

      it "increases the quality by 2 when there are 10 - 6 days till SellIn" do
        2.times { @gildedrose.update_quality }
        expect{ @gildedrose.update_quality }.to change { @backstagepasses.quality }. by 2
      end

      it "increases the quality by 3 when there are 5 - 0 days till SellIn" do
        7.times { @gildedrose.update_quality }
        expect{ @gildedrose.update_quality }.to change { @backstagepasses.quality }. by 3
      end

      it "drops quality to 0 when SellIn is 0" do
        13.times { @gildedrose.update_quality }
        expect(@backstagepasses.quality).to eq(0)
      end
    end

    # context "if the item is conjured" do
    #   it "decreases the quality by 2 if the SellIn date hasn't passed" do
    #
    #   end
    #
    #   it "decreases the quality by 4 if the SellIn date has passed" do
    #
    #   end
    end
  end
end

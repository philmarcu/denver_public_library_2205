require './lib/library'
require './lib/author'

RSpec.describe Library do
  before :each do
    @dpl = Library.new("Denver Public Library")
    @charlotte_bronte = Author.new({first_name: "Charlotte", last_name: "Bronte"})
    @harper_lee = Author.new({first_name: "Harper", last_name: "Lee"})

    @jane_eyre = @charlotte_bronte.write("Jane Eyre", "October 16, 1847")
    @professor = @charlotte_bronte.write("The Professor", "1857")
    @villette = @charlotte_bronte.write("Villette", "1853")

    @mockingbird = @harper_lee.write("To Kill a Mockingbird", "July 11, 1960")
  end

  it 'exists & has attributes' do
    expect(@dpl).to be_a(Library)
    expect(@dpl.name).to eq("Denver Public Library")
    expect(@dpl.books).to eq([])
    expect(@dpl.authors).to eq([])
  end

  it 'can add authors & their books' do
    @charlotte_bronte.add_books(@jane_eyre)
    @charlotte_bronte.add_books(@professor)
    @charlotte_bronte.add_books(@villette)
    @harper_lee.add_books(@mockingbird)

    @dpl.add_author(@charlotte_bronte)
    @dpl.add_author(@harper_lee)

    expected = @dpl.authors.first.books[0]

    expect(@dpl.authors).to eq([@charlotte_bronte, @harper_lee])
    expect(@dpl.books).to eq([@jane_eyre, @professor, @villette, @mockingbird])
    expect(expected).to eq(@jane_eyre)
    expect(expected.title).to eq("Jane Eyre")
    expect(@dpl.books.last.publication_year).to eq("1960")
  end

  it 'gives a publication_time_frame_for an author' do
    @charlotte_bronte.add_books(@jane_eyre)
    @charlotte_bronte.add_books(@professor)
    @charlotte_bronte.add_books(@villette)
    @harper_lee.add_books(@mockingbird)

    @dpl.add_author(@charlotte_bronte)
    @dpl.add_author(@harper_lee)

    expected_1 = {:start=>"1847", :end=>"1857"}
    expected_2 = {:start=>"1960", :end=>"1960"}

    expect(@dpl.publication_time_frame_for(@charlotte_bronte)).to eq(expected_1)
    expect(@dpl.publication_time_frame_for(@harper_lee)).to eq(expected_2)
  end

  it 'can checkout books' do
    @dpl.checkout(@mockingbird)
    @dpl.checkout(@jane_eyre)
    expect(@dpl.checkout(@mockingbird)).to eq(false)
    expect(@dpl.checkout(@jane_eyre)).to eq(false)

    @charlotte_bronte.add_books(@jane_eyre)
    @charlotte_bronte.add_books(@professor)
    @charlotte_bronte.add_books(@villette)
    @harper_lee.add_books(@mockingbird)

    @dpl.add_author(@charlotte_bronte)
    @dpl.add_author(@harper_lee)

    expect(@dpl.checkout(@mockingbird)).to eq(true)
    expect(@dpl.checkout(@jane_eyre)).to eq(true)
  end

  xit 'can return false if already checked out' do
    @charlotte_bronte.add_books(@jane_eyre)
    @charlotte_bronte.add_books(@professor)
    @charlotte_bronte.add_books(@villette)
    @harper_lee.add_books(@mockingbird)

    @dpl.add_author(@charlotte_bronte)
    @dpl.add_author(@harper_lee)
    @dpl.checkout(@mockingbird)
    @dpl.checkout(@jane_eyre)

    expect(@dpl.checkout(@mockingbird)).to eq(false)
    expect(@dpl.checkout(@jane_eyre)).to eq(false)
  end
end

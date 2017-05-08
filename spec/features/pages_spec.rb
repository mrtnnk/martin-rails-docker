require 'rails_helper'

feature 'Page management', js: true do
  let!(:example_page) { create(:page) }

  scenario 'User navigates through pages' do
    visit pages_path

    expect(page).to have_selector('h1', text: 'Pages')
    expect(page).to have_xpath('.//table/tbody/tr', count: 1)
    expect(page).to have_link(href: edit_page_path(example_page))
    expect(page).to have_link('Add new Page', href: new_page_path)

    # Go to single page by clicking on a row
    find(:xpath, ".//table/tbody/tr[1]").click
    expect(page.current_path).to eq(page_path(example_page))

    # Go to home page by clicking an the navbar logo
    find(:xpath, './/a[contains(@class, "navbar-brand")]').click
    expect(page.current_path).to eq(root_path)
  end

  scenario 'User edits an existing page' do
    visit page_path(example_page)

    expect(page).to have_selector('h1', text: 'Foo')
    expect(page).to have_link(href: edit_page_path(example_page))

    click_on 'Edit'

    expect(page.current_path).to eq(edit_page_path(example_page))
    expect(page).to have_selector('h1', text: 'Editing Page')
    expect(page).to have_button('Update Page')

    fill_in 'Title', with: 'Bar'
    fill_in 'Content', with: 'dolor sit amet'
    click_on 'Update Page'

    expect(page.current_path).to eq(page_path(example_page))
    expect(page).to have_text 'Page was successfully updated.'
    expect(page).to have_selector('h1', text: 'Bar')
    expect(page).to have_selector('p', text: 'dolor sit amet')
  end

  scenario 'User deletes an existing page' do
    visit pages_path

    expect(page).to have_selector('h1', text: 'Pages')

    page.accept_alert 'Are you sure?' do
      find(:xpath, '//table/tbody/tr[1]//a[@title="Destroy"]').click
    end

    expect(page.current_path).to eq(pages_path)
    expect(page).to have_text 'Page was successfully destroyed.'
    expect(page).to have_xpath('.//table/tbody/tr', count: 0)
  end

  scenario 'User creates a new page' do
    visit pages_path

    click_on 'Add new Page'

    expect(page.current_path).to eq(new_page_path)
    expect(page).to have_selector('h1', text: 'New Page')
    expect(page).to have_button('Create Page')

    fill_in 'Title', with: 'Bar'
    fill_in 'Content', with: 'dolor sit amet'
    click_on 'Create Page'

    expect(page).to have_text 'Page was successfully created.'
    expect(page).to have_selector('h1', text: 'Bar')
    expect(page).to have_selector('p', text: 'dolor sit amet')
  end
end

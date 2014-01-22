module InstallationStepHelper

 def self.fill_in_installation_values(page,installation_values_to_fill_in)
  page.fill_in "installation_name",  with: installation_values_to_fill_in['Name'] if installation_values_to_fill_in['Name']
  page.fill_in "installation_phone", with: installation_values_to_fill_in['Phone'] if installation_values_to_fill_in['Phone']
  page.fill_in "installation_designation", with: installation_values_to_fill_in['Designation'] if installation_values_to_fill_in['Designation']
  page.fill_in "installation_start_hour_of_concern", with: installation_values_to_fill_in['Investigation Start'] if installation_values_to_fill_in['Investigation Start']
  page.fill_in "installation_end_hour_of_concern",   with: installation_values_to_fill_in['Investigation End'] if installation_values_to_fill_in['Investigation End']
  page.fill_in "installation_photo_refreshes_per_day",   with: installation_values_to_fill_in['Photo Refreshes Per Day'] if installation_values_to_fill_in['Photo Refreshes Per Day']
  page.fill_in "installation_interrupt_duration",   with: installation_values_to_fill_in['Interrupt Duration'] if installation_values_to_fill_in['Interrupt Duration']
 end


end
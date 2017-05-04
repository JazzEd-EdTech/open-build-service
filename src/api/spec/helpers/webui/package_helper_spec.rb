require 'rails_helper'

RSpec.describe Webui::PackageHelper, type: :helper do
  describe '#nbsp' do
    it 'produces a SafeBuffer' do
      sanitized_string = nbsp("a")
      expect(sanitized_string).to be_a(ActiveSupport::SafeBuffer)
    end

    it 'escapes html' do
      sanitized_string = nbsp('<b>unsafe<b/>')
      expect(sanitized_string).to eq('&lt;b&gt;unsafe&lt;b/&gt;')
    end

    it 'converts space to nbsp' do
      sanitized_string = nbsp("my file")
      expect(sanitized_string).to eq('my&nbsp;file')
    end

    it 'breaks up long strings' do
      long_string = "a" * 50 + "b" * 50 + "c" * 10
      sanitized_string = nbsp(long_string)
      expect(long_string.scan(/.{1,50}/).join("<wbr>")).to eq(sanitized_string)
    end
  end

  describe '#title_or_name' do
    it 'returns package name when title is empty' do
      package = create(:package, name: 'openSUSE', title: '')
      expect(title_or_name(package)).to eq('openSUSE')
    end

    it 'returns package name when title is nil' do
      package = create(:package, name: 'openSUSE', title: nil)
      expect(title_or_name(package)).to eq('openSUSE')
    end

    it 'returns package title when title is set' do
      package = create(:package, name: 'openSUSE', title: 'Leap')
      expect(title_or_name(package)).to eq('Leap')
    end
  end

  describe '#humanize_time' do
    it 'returns seconds' do
      expect(humanize_time(28)).to eq('28s')
    end

    it 'returns minutes and seconds' do
      expect(humanize_time(88)).to eq('1m 28s')
    end

    it 'returns hours, minutes and seconds' do
      expect(humanize_time(3688)).to eq('1h 1m 28s')
    end
  end

  describe '#file_url' do
    skip
  end

  describe '#rpm_url' do
    skip
  end

  describe '#human_readable_fsize' do
    skip
  end

  describe '#guess_code_class' do
    skip
  end

  describe '#package_bread_crumb' do
    skip
  end

  describe '#binaries?' do
    context 'with a buildresult with one result' do
      let(:subject) {
        {
          result: {
            binarylist: {
              binary: [
                { filename: '_buildenv', size: '13722', mtime: '1493898933' }
              ]
            }
          }
        }.with_indifferent_access
      }

      it 'returns true' do
        expect(binaries?(subject)).to eq(true)
      end
    end

    context 'with a buildresult with more than one result' do
      let(:subject) {
        {
          result: [
            {
              binarylist: {
                binary: [
                  { filename: '_buildenv', size: '13722', mtime: '1493898933' }
                ]
              }
            },
            {
              binarylist: {
                binary: [
                  { filename: '_buildenv', size: '13722', mtime: '1493898933' }
                ]
              }
            }
          ]
        }.with_indifferent_access
      }

      it 'returns true' do
        expect(binaries?(subject)).to eq(true)
      end
    end

    context 'with a buildresult without any result' do
      let(:subject) { ActiveSupport::HashWithIndifferentAccess.new }

      it 'returns false' do
        expect(binaries?(subject)).to eq(false)
      end
    end

    context 'with a buildresult without a binarylist' do
      let(:subject) { { result: ActiveSupport::HashWithIndifferentAccess.new } }

      it 'returns false' do
        expect(binaries?(subject)).to eq(false)
      end
    end
  end
end

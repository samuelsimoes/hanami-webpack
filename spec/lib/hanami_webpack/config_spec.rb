require 'hanami_webpack/config'

RSpec.describe(HanamiWebpack::Config) do
  let(:config) { described_class.new(env: fake_env) }

  let(:fake_env) do
    {
      'INBUILT_WEBPACK_DEV_SERVER' => 'sampel_inbuilt_webpack_dev_server',
      'RACK_ENV' => 'sample_rack_env',
      'WEBPACK_DEV_SERVER' => 'sample_webpack_dev_server',
      'WEBPACK_DEV_SERVER_HOST' => 'sample_webpack_dev_server_host',
      'WEBPACK_DEV_SERVER_PORT' => 'sample_webpack_dev_server_port',
      'WEBPACK_MANIFEST_FILE' => 'sample_webpack_manifest_file',
      'WEBPACK_PUBLIC_PATH' => 'sample_webpack_public_path'
    }
  end

  describe '#dev_server_host' do
    subject { config.dev_server_host }

    it 'fetches value for WEBPACK_DEV_SERVER_HOST key from env' do
      is_expected.to eq('sample_webpack_dev_server_host')
    end
  end

  describe '#dev_server_port' do
    subject { config.dev_server_port }

    it 'fetches value for WEBPACK_DEV_SERVER_PORT key from env' do
      is_expected.to eq('sample_webpack_dev_server_port')
    end
  end

  describe '#inbuilt_dev_server?' do
    subject { config.inbuilt_dev_server? }

    context "when value for INBUILT_WEBPACK_DEV_SERVER key in env is 'true'" do
      let(:fake_env) do
        super().merge({ 'INBUILT_WEBPACK_DEV_SERVER' => 'true' })
      end

      it { is_expected.to eq(true) }
    end

    context "when value for INBUILT_WEBPACK_DEV_SERVER key in env is any other than 'true'" do
      let(:fake_env) do
        super().merge({ 'INBUILT_WEBPACK_DEV_SERVER' => '' })
      end

      it { is_expected.to eq(false) }
    end
  end

  describe '#manifest_file' do
    subject { config.manifest_file }

    it 'fetches value for WEBPACK_MANIFEST_FILE key from env' do
      is_expected.to eq('sample_webpack_manifest_file')
    end
  end

  describe '#public_path' do
    subject { config.public_path }

    it 'fetches value for WEBPACK_PUBLIC_PATH key from env' do
      is_expected.to eq('sample_webpack_public_path')
    end
  end

  describe 'using_dev_server?' do
    subject { config.using_dev_server? }

    context 'when value for WEBPACK_DEV_SERVER key in env is blank' do
      let(:fake_env) do
        super().merge({ 'WEBPACK_DEV_SERVER' => '' })
      end

      context 'when value for RACK_ENV key in env is "production"' do
        let(:fake_env) do
          super().merge({ 'RACK_ENV' => 'production' })
        end

        it { is_expected.to eq(false) }
      end

      context 'when value for RACK_ENV key in env is any other than "production"' do
        let(:fake_env) do
          super().merge({ 'RACK_ENV' => 'development' })
        end

        it { is_expected.to eq(true) }
      end
    end

    context 'when value for WEBPACK_DEV_SERVER key in env is not blank' do
      context "when value for WEBPACK_DEV_SERVER key in env is 'true'" do
        let(:fake_env) do
          super().merge({ 'WEBPACK_DEV_SERVER' => 'true' })
        end

        it { is_expected.to eq(true) }
      end

      context "when value for WEBPACK_DEV_SERVER key in env is any other than 'true'" do
        let(:fake_env) do
          super().merge({ 'WEBPACK_DEV_SERVER' => 'false' })
        end

        it { is_expected.to eq(false) }
      end
    end
  end

  describe '.config' do
    it 'creates new object of self class with ENV set as env variable and memoizes it', aggregate_failures: true do
      expect { described_class.config }.to change { ObjectSpace.each_object(described_class).count }.by(1)
      expect { described_class.config }.not_to change { ObjectSpace.each_object(described_class).count }

      config = described_class.config
      expect(config).to be_a(described_class)
      expect(config.env).to eq(ENV)
    end
  end

  shared_examples 'it delegates class method to the instance initialized in .config method' do |method_name|
    it "delegates .#{method_name} class method to the instance initialized in .config method" do
      stubbed_value = "value stubbed for #{method_name}"
      fake_config = double(:config, method_name => stubbed_value)
      allow(described_class).to receive(:config).and_return(fake_config)

      expect(described_class.send(method_name)).to eq(stubbed_value)
    end
  end

  describe '.dev_server_host' do
    include_examples 'it delegates class method to the instance initialized in .config method', :dev_server_host
  end

  describe '.dev_server_port' do
    include_examples 'it delegates class method to the instance initialized in .config method', :dev_server_port
  end

  describe '.inbuilt_dev_server?' do
    include_examples 'it delegates class method to the instance initialized in .config method', :inbuilt_dev_server?
  end

  describe '.manifest_file' do
    include_examples 'it delegates class method to the instance initialized in .config method', :manifest_file
  end

  describe '.public_path' do
    include_examples 'it delegates class method to the instance initialized in .config method', :public_path
  end

  describe '.using_dev_server?' do
    include_examples 'it delegates class method to the instance initialized in .config method', :using_dev_server?
  end
end

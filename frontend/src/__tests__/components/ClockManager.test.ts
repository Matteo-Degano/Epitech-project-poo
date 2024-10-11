import { mount } from '@vue/test-utils';
import { describe, it, expect, beforeEach, afterEach, vi } from 'vitest';
import ClockManager from '@/components/ClockManager.vue';
import { fetchData } from "@/services/api";

vi.mock('@/stores/user', () => ({
  useUserStore: () => ({
    userId: 1, 
  }),
}));

vi.mock('@/services/api', () => ({
  fetchData: vi.fn(),
}));

describe('ClockManager', () => {
  let wrapper: any;

  beforeEach(() => {
    wrapper = mount(ClockManager);
  });

  afterEach(() => {
    vi.clearAllMocks(); 
    wrapper.unmount();
  });

  describe('Clock functionality', () => {
    it('should start the clock when clicking Start', async () => {
      const startButton = wrapper.findAll('button').find((btn: { text: () => string; }) => btn.text() === 'Start');
      if (startButton) {
        await startButton.trigger('click');
      }
      expect(wrapper.vm.clockIn).toBe(true);
      expect(fetchData).toHaveBeenCalledWith('POST', '/clocks/1', expect.any(Object));
    });

    it('should pause the clock when clicking Pause', async () => {
      const startButton = wrapper.findAll('button').find((btn: { text: () => string; }) => btn.text() === 'Start');
      if (startButton) {
        await startButton.trigger('click');
      }
      const pauseButton = wrapper.findAll('button').find((btn: { text: () => string; }) => btn.text() === 'Pause');
      if (pauseButton) {
        await pauseButton.trigger('click');
      }
      expect(wrapper.vm.clockIn).toBe(false);
    });

    it('should reset the time and clockIn when clicking Stop', async () => {
      const startButton = wrapper.findAll('button').find((btn: { text: () => string; }) => btn.text() === 'Start');
      if (startButton) {
        await startButton.trigger('click');
      }
      const stopButton = wrapper.findAll('button').find((btn: { text: () => string; }) => btn.text() === 'Stop');
      if (stopButton) {
        await stopButton.trigger('click');
      }
      expect(fetchData).toHaveBeenCalledWith('POST', '/workingtime/1', expect.any(Object));
      expect(wrapper.vm.time).toBe("00:00:00");
      expect(wrapper.vm.clockIn).toBe(false);
    });
  });

  describe('Utility functions', () => {
    it('should format the date correctly', () => {
      const timestamp = new Date('2024-01-01T00:00:00Z').getTime();
      const formattedDate = wrapper.vm.formatDate(timestamp);
      expect(formattedDate).toBe('01/01/2024');
    });
  });
});
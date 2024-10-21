import { mount } from '@vue/test-utils';
import { describe, it, expect, vi } from 'vitest';
import NavigationMenu from '@/components/ui/navigationMenu/NavigationMenu.vue';

describe('NavigationMenu', () => {
  it('renders the menu items correctly', () => {
    const wrapper = mount(NavigationMenu);
    const menuItems = wrapper.findAll('ul > li > a');
    
    expect(menuItems.length).toBe(3);
    expect(menuItems[0].text()).toBe('Accueil');
    expect(menuItems[1].text()).toBe('À propos');
    expect(menuItems[2].text()).toBe('Services');
  });

  it('renders the ClockManager component', () => {
    const wrapper = mount(NavigationMenu);
    const clockManager = wrapper.findComponent({ name: 'ClockManager' });
    
    expect(clockManager.exists()).toBe(true);
  });
});

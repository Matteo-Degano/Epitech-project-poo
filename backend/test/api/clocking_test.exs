defmodule Api.ClockTest do
  use Api.DataCase

  alias Api.Clocks

  describe "clocks" do
    alias Api.Clocks.Clock

    import Api.ClockFixtures

    @invalid_attrs %{status: nil, time: nil}

    test "list_clocks/0 returns all clocks" do
      clocks = clocks_fixture()
      assert Clock.list_clocks() == [clocks]
    end

    test "get_clocks!/1 returns the clocks with given id" do
      clocks = clocks_fixture()
      assert Clocks.get_clocks!(clocks.id) == clocks
    end

    test "create_clocks/1 with valid data creates a clocks" do
      valid_attrs = %{status: true, time: ~N[2024-10-07 14:13:00]}

      assert {:ok, %Clock{} = clocks} = Clock.create_clocks(valid_attrs)
      assert clocks.status == true
      assert clocks.time == ~N[2024-10-07 14:13:00]
    end

    test "create_clocks/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Clocks.create_clocks(@invalid_attrs)
    end

    test "update_clocks/2 with valid data updates the clocks" do
      clocks = clocks_fixture()
      update_attrs = %{status: false, time: ~N[2024-10-08 14:13:00]}

      assert {:ok, %Clock{} = clocks} = Clocks.update_clocks(clocks, update_attrs)
      assert clocks.status == false
      assert clocks.time == ~N[2024-10-08 14:13:00]
    end

    test "update_clocks/2 with invalid data returns error changeset" do
      clocks = clocks_fixture()
      assert {:error, %Ecto.Changeset{}} = Clocks.update_clocks(clocks, @invalid_attrs)
      assert clocks == Clocks.get_clocks!(clocks.id)
    end

    test "delete_clocks/1 deletes the clocks" do
      clocks = clocks_fixture()
      assert {:ok, %Clock{}} = Clocks.delete_clocks(clocks)
      assert_raise Ecto.NoResultsError, fn -> Clocks.get_clocks!(clocks.id) end
    end

    test "change_clocks/1 returns a clocks changeset" do
      clocks = clocks_fixture()
      assert %Ecto.Changeset{} = Clocks.change_clocks(clocks)
    end
  end
end

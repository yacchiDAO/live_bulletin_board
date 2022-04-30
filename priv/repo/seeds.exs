# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     BulletinBoard.Repo.insert!(%BulletinBoard.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

import BulletinBoard.Repo
alias BulletinBoard.Threads.Thread
alias BulletinBoard.Posts.Post

thread1 = insert!(%Thread{ title: "スレ立てたお" })
thread2 = insert!(%Thread{ title: "スレ立てたおpart2" })
insert!(%Post{ thread_id: thread1.id, number: 1, name: "名無しさん", body: "1です" })
insert!(%Post{ thread_id: thread1.id, number: 2, name: "ほげほげ", body: "サンキューー >>1" })
insert!(%Post{ thread_id: thread1.id, number: 3, name: "ああああ", body: "スレ立て乙" })
insert!(%Post{ thread_id: thread2.id, number: 1, name: "名無しさん", body: "おっおっ" })
